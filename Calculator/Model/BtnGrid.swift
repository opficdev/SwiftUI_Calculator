//
//  BtnGrid.swift
//  Calculator
//
//  Created by opfic on 11/18/24.
//

import Foundation

let portraitBtn: [[BtnType]] = [
    [.allClear, .oppo, .perc, .div],
    [._7, ._8, ._9, .mul],
    [._4, ._5, ._6, .sub],
    [._1, ._2, ._3, .add],
    [.emoji, ._0, .dot, .equal]
]

let landscapeBtn: [[BtnType]] = [
    [._7, ._8, ._9, .allClear, .div],
    [._4, ._5, ._6, .oppo, .mul],
    [._1, ._2, ._3, .perc, .sub],
    [.emoji, ._0, .dot, .equal, .add]
]

let scientificBtn: [[BtnType]] = [
    [.lbrac, .rbrac, .mc, .m_add, .m_sub, .mr],
    [._2nd, .x2, .x3, .xy, .ex, .tenx],
    [.rev, .x_2, .x_3, .x_y, .ln, .log10],
    [.xf, .sin, .cos, .tan, .e, .EE],
    [.rand, .sinh, .cosh, .tanh, .pi, .deg]
]
