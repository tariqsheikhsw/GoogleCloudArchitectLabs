
# Set text styles
YELLOW=$(tput setaf 3)
BOLD=$(tput bold)
RESET=$(tput sgr0)

gcloud auth list

gcloud config set project $DEVSHELL_PROJECT_ID

cat > redact-request.json <<EOF_CP
{
	"item": {
		"value": "Please update my records with the following information:\n Email address: foo@example.com,\nNational Provider Identifier: 1245319599"
	},
	"deidentifyConfig": {
		"infoTypeTransformations": {
			"transformations": [{
				"primitiveTransformation": {
					"replaceWithInfoTypeConfig": {}
				}
			}]
		}
	},
	"inspectConfig": {
		"infoTypes": [{
				"name": "EMAIL_ADDRESS"
			},
			{
				"name": "US_HEALTHCARE_NPI"
			}
		]
	}
}
EOF_CP



curl -s \
  -H "Authorization: Bearer $(gcloud auth print-access-token)" \
  -H "Content-Type: application/json" \
  https://dlp.googleapis.com/v2/projects/$DEVSHELL_PROJECT_ID/content:deidentify \
  -d @redact-request.json -o redact-response.txt


gsutil cp redact-response.txt gs://$DEVSHELL_PROJECT_ID-redact


cat > template.json <<EOF_CP
{
	"deidentifyTemplate": {
	  "deidentifyConfig": {
		"recordTransformations": {
		  "fieldTransformations": [
			{
			  "fields": [
				{
				  "name": "bank name"
				},
				{
				  "name": "zip code"
				}
				
			  ],
			  "primitiveTransformation": {
				"characterMaskConfig": {
				  "maskingCharacter": "#"
				  
				}
				
			  }
			  
			}
			
		  ]
		  
		}
		
	  },
	  "displayName": "structured_data_template"
	  
	},
	"locationId": "global",
	"templateId": "structured_data_template"
  }
EOF_CP


curl -s \
-H "Authorization: Bearer $(gcloud auth application-default print-access-token)" \
-H "Content-Type: application/json" \
https://dlp.googleapis.com/v2/projects/$DEVSHELL_PROJECT_ID/deidentifyTemplates \
-d @template.json

cat > template.json <<'EOF_CP'
{
  "deidentifyTemplate": {
    "deidentifyConfig": {
      "infoTypeTransformations": {
        "transformations": [
          {
            "infoTypes": [
              {
                "name": ""
                
              }
              
            ],
            "primitiveTransformation": {
              "replaceConfig": {
                "newValue": {
                  "stringValue": "[redacted]"
                  
                }
              }
              
            }
          }
          
        ]
      }
      
    },
    "displayName": "unstructured_data_template"
    
  },
  "templateId": "unstructured_data_template",
  "locationId": "global"
}
EOF_CP



curl -s \
-H "Authorization: Bearer $(gcloud auth application-default print-access-token)" \
-H "Content-Type: application/json" \
https://dlp.googleapis.com/v2/projects/$DEVSHELL_PROJECT_ID/deidentifyTemplates \
-d @template.json


echo ""

echo "Open this below link to create a de-identify template for structured data"

echo "${YELLOW}${BOLD}[https://console.cloud.google.com/security/sensitive-data-protection/projects/$DEVSHELL_PROJECT_ID/locations/global/deidentifyTemplates/structured_data_template/edit?project=$DEVSHELL_PROJECT_ID]${RESET}"

echo ""

echo "Open this below link to create a de-identify template for unstructured data"

echo "${YELLOW}${BOLD}[https://console.cloud.google.com/security/sensitive-data-protection/projects/$DEVSHELL_PROJECT_ID/locations/global/deidentifyTemplates/unstructured_data_template/edit?project=$DEVSHELL_PROJECT_ID]${RESET}"

echo ""

