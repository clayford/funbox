#' Cardiovascular Changes and Plasma Drug Levels after Amitriptyline Overdose
#'
#' Data on overdoses of the drug amitriptyline (Rudorfer, 1982)
#'
#' @format
#' A data frame with 17 rows and 7 columns:
#' \describe{
#'   \item{TOT}{total TCAD plasma level }
#'   \item{AMI}{amount of amitriptyline present in the TCAD plasma level}
#'   \item{GEN}{gender (male = 0, female = 1)}
#'   \item{AMT}{amount of drug taken at time of overdose}
#'   \item{PR}{PR wave measurement}
#'   \item{DIAP}{diastolic blood pressure}
#'   \item{QRS}{QRS wave measurement}
#' }
#'
#' @references Rudorfer MV (1982). “Cardiovascular Changes and Plasma Drug Levels after Amitriptyline Overdose.” Journal of Toxicology-Clinical Toxicology, 19, 67-71.
#' @source Johnson R and Wichern D (2007). Applied Multivariate Statistical Analysis, Sixth Edition. Prentice-Hall. (Exercise 7.25)
#'
#' @examples
#' # Example of multivariate multiple regression
#' # https://library.virginia.edu/data/articles/getting-started-with-multivariate-multiple-regression
#' m <- lm(cbind(TOT, AMI) ~ GEN + AMT + PR + DIAP + QRS, data = ami)
#' summary(m)
"ami"

