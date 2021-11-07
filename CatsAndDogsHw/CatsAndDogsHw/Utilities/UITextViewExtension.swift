//
//  UITextViewExtension.swift
//  CatsAndDogsHw
//
//  Created by Rishat on 06.11.2021.
//

import UIKit

//MARK: - UITextView Extension

extension UITextView {
    
    func centerText() {

        self.textAlignment = .center
        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fittingSize)
        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        contentOffset.y = -positiveTopOffset

    }

}
