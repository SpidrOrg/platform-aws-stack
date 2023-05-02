include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../../_terraform_modules/terraform-aws-krny-glue/glue_classifier//."
}

locals {
  # Automatically load input variables
  common_vars = read_terragrunt_config(find_in_parent_folders("common_vars.hcl"))
}





inputs = merge(
  local.common_vars.inputs,
  {
    
    classifier_name_1 = "transformeddata_crawler_classifier"
    allow_single_column_1 = true
    contains_header_1 = "PRESENT"
    delimiter_1 = ","
    disable_value_trimming_1 = false
    header_1 = []
    quote_symbol_1 = "\""

    classifier_name_2 = "cleaneddata_crawler_classifier"
    allow_single_column_2 = false
    contains_header_2 = "PRESENT"
    delimiter_2 = ","
    disable_value_trimming_2 = true
    header_2 = []
    quote_symbol_2 = "\""

  
  }
)
