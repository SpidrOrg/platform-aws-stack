provider "aws" {
  region = "us-east-1"
}

resource "aws_glue_classifier" "csv_classifier_1" {
  name = var.classifier_name_1

  csv_classifier {
    allow_single_column    = var.allow_single_column_1
    contains_header        = var.contains_header_1
    delimiter              = var.delimiter_1
    disable_value_trimming = var.disable_value_trimming_1
    header                 = var.header_1
    quote_symbol           = var.quote_symbol_1
  }
}

resource "aws_glue_classifier" "csv_classifier_2" {
  name = var.classifier_name_2

  csv_classifier {
    allow_single_column    = var.allow_single_column_2
    contains_header        = var.contains_header_2
    delimiter              = var.delimiter_2
    disable_value_trimming = var.disable_value_trimming_2
    header                 = var.header_2
    quote_symbol           = var.quote_symbol_2
  }
}
