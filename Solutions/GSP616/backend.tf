/**
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

terraform {
  backend "gcs" {
    bucket = "qwiklabs-gcp-03-ce898f83d9ab-state-bucket" # Edit this this line to match your lab-networking/networking backend.tf file
    prefix = "terraform/lab/vm"
  }
}

data "terraform_remote_state" "network" {
  backend = "gcs"

  config = {
    bucket = "qwiklabs-gcp-03-ce898f83d9ab-state-bucket" # Update this too
    prefix = "terraform/lab/network"
  }
}
