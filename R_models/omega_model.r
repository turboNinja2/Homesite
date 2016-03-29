
model_name <- 'omega'

master_formula <-   "~ . 
			  +PropertyField37*PersonalField10A
              +PropertyField37*PersonalField10B
              +PropertyField37*PersonalField9
              +day*SalesField7
              +PersonalField12*SalesField5
              +SalesField5*Field7
              +PersonalField12*Field7
              +PersonalField9*Field7
              +PersonalField9*SalesField5
              +CoverageField9*Field7
              +PersonalField12*SalesField4
              +SalesField4*Field7
              +PropertyField8*PersonalField17
              +PropertyField8*PersonalField19
              +PropertyField8*PersonalField18
              +PropertyField8*PersonalField16
              +PropertyField8*PersonalField84
              +PersonalField12*CoverageField9
              +GeographicField22B*GeographicField5B
              +PersonalField1*SalesField5
              +PropertyField29*PersonalField12
              +SalesField5*SalesField1A
              +PropertyField8*PersonalField33
              +PropertyField8*PersonalField47
              +PropertyField8*PersonalField77
              +PropertyField29*SalesField5
              +CoverageField8*Field7
              +SalesField5*SalesField1B
              +PropertyField8*PersonalField15
              +PersonalField12*SalesField1B
              +PropertyField8*PersonalField32
              +PropertyField8*PersonalField46
              +PropertyField8*PersonalField76
              +PropertyField29*PersonalField9
              +PersonalField9*SalesField4
              +PersonalField9*SalesField1B
              +CoverageField9*CoverageField8
              +PersonalField9*CoverageField9
              +PersonalField12*Field8
              +PersonalField12*Field6
              +CoverageField8*Field8
              +PropertyField8*PersonalField78
              +PropertyField8*PersonalField29
              +PropertyField29*SalesField1A
              +PropertyField8*PersonalField48
              +PersonalField12*Field10
              +GeographicField64*PersonalField12
              +PersonalField12*Field11

			  +PropertyField29 * SalesField1B
				+PersonalField12 * SalesField1A
				+CoverageField9 * Field9
				+SalesField5 * CoverageField9
				+PersonalField12 * Field9
				+CoverageField8 * Field10
				+PersonalField84 * Field8
					
			+GeographicField64 * PersonalField27
			+GeographicField22B * GeographicField21B
			+PersonalField84 * Field11
			+PropertyField34 * CoverageField9
			+SalesField5 * SalesField2A
			+PersonalField84 * Field6
			
			+GeographicField22B * PersonalField18
			+GeographicField64 * PersonalField84
			+PersonalField84 * Field10
			+SalesField4 * SalesField1A
			+GeographicField22B * PersonalField17
			+GeographicField22B * PersonalField16
					
              - 1"

			  
			  
master_formula <- gsub(x = master_formula,pattern = "\n",replacement = "",fixed = T)
load(file = './cleandata.Rdata')

source('./_run_lasso.R')



