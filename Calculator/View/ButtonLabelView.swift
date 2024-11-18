//
//  ButtonLabelView.swift
//  Calculator
//
//  Created by opfic on 11/5/24.
//

import SwiftUI

struct ButtonLabelView: View {
    let button: button
    
    var body: some View {
        if let image = button.image {
            image
        }
        else if let text = button.string {
            Text(text)
        }
    }
}
