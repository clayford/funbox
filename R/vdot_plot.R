#' Dot plot and violin plot
#'
#' Create a Wilkinson dot plot overlaying a violin plot using ggplot2. The Wilkinson dot plot shows each observation as a dot. The violin plot provides a distribution density estimate. This function basically implements \href{https://hbiostat.org/bbr/descript#fig-descript-vplot}{Fig 4.26} from Frank Harrell's \href{https://hbiostat.org/bbr/}{Biostatistics for Biomedical Research book}.
#'
#' @param formula a model formula of the form y ~ x or, if plotting by groups, y ~ x | z, where z evaluates to a factor or other variable dividing the data into groups. If x or z is not a factor, the function converts them to a factor.
#' @param data data frame within which to evaluate the formula.
#'
#' @returns Returns a Wilkinson dot chart overlaying a violin plot.
#' @export
#'
#' @examples
#' vdot_plot(mpg ~ am, mtcars)
#' vdot_plot(mpg ~ am | vs, mtcars)
vdot_plot <- function(formula, data){
  if (!inherits(formula, "formula") | length(formula) != 3)
    stop("invalid formula")
  formula <- as.character(c(formula))
  formula <- stats::as.formula(sub("\\|", "+", formula))
  yx <- stats::model.frame(formula, data = data)
  if(ncol(yx) > 3 | ncol(yx) < 2)
    stop("Invalid formula. Acceptable formulas are either y ~ x or y ~ x | z.")
  vs <- names(yx)
  if(any(!sapply(yx[,-1], is.factor)))
    yx[,-1] <- lapply(yx[,-1, drop = FALSE], as.factor)
  if(ncol(yx) == 3){
    fg <- ggplot2::facet_wrap(ggplot2::vars(.data[[vs[3]]]),
                              labeller = "label_both")
  } else fg <- ggplot2::ylab(vs[1])
  ggplot2::ggplot(yx, ggplot2::aes(x = .data[[vs[2]]],
                                   y = .data[[vs[1]]])) +
    ggplot2::geom_violin(width=.6, col='lightblue') +
    ggplot2::geom_dotplot(binaxis='y', stackdir='center',
                          position='dodge', alpha=.4) +
    ggplot2::stat_summary(fun=stats::median, geom='point', color='blue',
                          shape='+', size=10) +
    fg +
    ggplot2::coord_flip()
}
