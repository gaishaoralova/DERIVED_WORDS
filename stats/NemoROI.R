#' NEMO region of interest recoding function
#'
#' This function will recode 10-10 electrode locations with the NEMO ROI labels
#' @param elec The 10-10 electrode label string
#' @return The ROI label

nemoROI <- function( elec ){
  
  switch( elec,
          
          ## LEFT TEMPORAL - FRONTAL
          AF7   = return("LT_F"),
          F7    = return("LT_F"),
          F9    = return("LT_F"),
          
          ## LEFT TEMPORAL - CENTRAL
          FT7   = return("LT_C"),
          FT9   = return("LT_C"),
          T7    = return("LT_C"),
          T9    = return("LT_C"),
          
          ## LEFT TEMPORAL - PARIETAL
          TP7   = return("LT_P"),
          TP9   = return("LT_P"),
          P7    = return("LT_P"),
          P9    = return("LT_P"),
          
          ## LEFT TEMPORAL - OCCIPITAL
          PO7   = return("LT_O"),
          PO9   = return("LT_O"),
          I1    = return("LT_O"),
          
          ## LEFT - FRONTAL
          AF3   = return("L_F"),
          AF5   = return("L_F"),
          F3    = return("L_F"),
          F5    = return("L_F"),
          
          ## LEFT - CENTRAL
          FC3   = return("L_C"),
          FC5   = return("L_C"),
          C3    = return("L_C"),
          C5    = return("L_C"),
          
          ## LEFT - PARIETAL
          CP3   = return("L_P"),
          CP5   = return("L_P"),
          P3    = return("L_P"),
          P5    = return("L_P"),
          
          ## LEFT - OCCIPITAL
          PO3   = return("L_O"),
          PO5   = return("L_O"),
          O1    = return("L_O"),
          
          ## MIDDLE - FRONTAL
          AFz   = return("M_F"),
          AF1   = return("M_F"),
          AF2   = return("M_F"),
          Fz    = return("M_F"),
          F1    = return("M_F"),
          F2    = return("M_F"),
          
          ## MIDDLE - CENTRAL
          FCz   = return("M_C"),
          FC1   = return("M_C"),
          FC2   = return("M_C"),
          Cz    = return("M_C"),
          C1    = return("M_C"),
          C2    = return("M_C"),
          
          ## MIDDLE - PARIETAL
          CPz   = return("M_P"),
          CP1   = return("M_P"),
          CP2   = return("M_P"),
          Pz    = return("M_P"),
          P1    = return("M_P"),
          P2    = return("M_P"),
          
          ## MIDDLE - OCCIPITAL
          POz   = return("M_O"),
          PO1   = return("M_O"),
          PO2   = return("M_O"),
          Oz    = return("M_O"),
          
          ## RIGHT - FRONTAL
          AF4   = return("R_F"),
          AF6   = return("R_F"),
          F4    = return("R_F"),
          F6    = return("R_F"),
          
          ## RIGHT - CENTRAL
          FC4   = return("R_C"),
          FC6   = return("R_C"),
          C4    = return("R_C"),
          C6    = return("R_C"),
          
          ## RIGHT - PARIETAL
          CP4   = return("R_P"),
          CP6   = return("R_P"),
          P4    = return("R_P"),
          P6    = return("R_P"),
          
          ## RIGHT - OCCIPITAL
          PO4   = return("R_O"),
          PO6   = return("R_O"),
          O2    = return("R_O"),
          
          ## RIGHT TEMPORAL - FRONTAL
          AF8   = return("RT_F"),
          F8    = return("RT_F"),
          F10   = return("RT_F"),
          
          ## RIGHT TEMPORAL - CENTRAL
          FT8   = return("RT_C"),
          FT10  = return("RT_C"),
          T8    = return("RT_C"),
          T10   = return("RT_C"),
          
          ## RIGHT TEMPORAL - PARIETAL
          P8   = return("RT_P"),
          P10  = return("RT_P"),
          TP8    = return("RT_P"),
          TP10   = return("RT_P"),
          
          ## RIGHT TEMPORAL - OCCIPITAL
          PO8   = return("RT_O"),
          PO10  = return("RT_O"),
          I2    = return("RT_O")
  )
  return("UNDEF")
}
