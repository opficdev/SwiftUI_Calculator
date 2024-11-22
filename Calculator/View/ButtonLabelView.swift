//
//  ButtonLabelView.swift
//  Calculator
//
//  Created by opfic on 11/5/24.
//

import SwiftUI

struct ButtonLabelView: View {
    let button: CalcButton
    
    var body: some View {
        if let image = button.image {   //  image에 대해 우선순위 부여
            image
        }
        else if let text = button.string {
            Text(text)
        }
    }
}
