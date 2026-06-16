dot_chart <- function(data, formula = NULL, segments = TRUE){
  if(is.null(formula)){
    i <- c(ncol(data), 1:(ncol(data) - 1))
    yx <- data[,i]
  } else yx <- model.frame(formula, data = data)
  if (ncol(yx) < 2)
    stop("fewer than two variables")
  if (ncol(yx) > 4)
    stop("more than four variables")
  vs <- names(yx)
  if(ncol(yx) == 3){
    fg <- ggplot2::facet_wrap(ggplot2::vars(.data[[vs[3]]]))
  } else if(ncol(yx) == 4){
    fg <- ggplot2::facet_grid(rows = ggplot2::vars(.data[[vs[3]]]),
                              cols = ggplot2::vars(.data[[vs[4]]]))
  } else fg <- ylab(vs[2])
  if(segments){
    seg <- ggplot2::geom_segment(ggplot2::aes(yend = .data[[vs[2]]]),
                                 xend = 0)
  } else seg <- ggplot2::geom_segment(ggplot2::aes(xend = .data[[vs[1]]],
                                                   yend = .data[[vs[2]]]))
  ggplot2::ggplot(yx, ggplot2::aes(x = .data[[vs[1]]],
                                   y=.data[[vs[2]]])) +
    ggplot2::geom_point() +
    seg +
    fg +
    ggplot2::xlab(vs[1])
}

