include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../_terraform_modules/terraform-aws-krny-glue/glue_crawler//."
}

locals {
  # Automatically load input variables
  common_vars = read_terragrunt_config(find_in_parent_folders("common_vars.hcl"))
}

dependency "covid-glue-role" {
  config_path = "../../07-iam/02-glue-roles/01-covid"
  mock_outputs = {
    iam_role_arn = "arn:aws:iam::123456789012:role/role_name"
  }
}


dependency "database_catalog_table" {
  config_path = "../database_catalog_and_ctlg_tables"
  mock_outputs = {
    database_name = "aws_athena"
  }
}

dependency "classifier-name-1" {
  config_path = "../classifier"
  mock_outputs = {
    classifier_name_1 = ["classifier-name-1"]
  }
}

dependency "classifier-name-2" {
  config_path = "../classifier"
  mock_outputs = {
    classifier_name_2 = ["classifier-name-2"]
  }
}


inputs = merge(
  local.common_vars.inputs,
  
  {
    classifier1 = [dependency.classifier-name-1.outputs.classifier_name_1]
    crawler1 = {
    name = "transformeddata-crawler"
    description = "Transformed data Glue Crawler"
    role_arn = dependency.covid-glue-role.outputs.iam_role_arn  
    
    catalog_target_tables = [
        "tfdata_covid",
        "tfdata_google_trends",
        "tfdata_fred",
        "tfdata_meteostat",
        "tfdata_similar_web",
        "tfdata_yahoo_finance",
        "tfdata_moodys",
        "tfdata_moodys_188",
        "tfdata_mnemonics",
        "tfdata_ihs_historical",
        "tfdata_ihs_pp"
                    ]
    }
},
  {
    classifier2 = [dependency.classifier-name-2.outputs.classifier_name_2]
    crawler2 = {
    name = "cleaneddata-crawler"
    description = "Transformed data Glue Crawler"
    role_arn = dependency.covid-glue-role.outputs.iam_role_arn  
    
    catalog_target_tables = [
        "cldata_covid",
        "cldata_google_trends",
        "cldata_fred",
        "cldata_meteostat",
        "cldata_similar_web",
        "cldata_moodys",
        "cldata_moodys_188",
        "cldata_yahoo_finance",
        "cldata_ihs_historical",
        "cldata_ihs_pp"
                    ]
}
  
database_name = dependency.database_catalog_table.outputs.database_name

  
  }
)
