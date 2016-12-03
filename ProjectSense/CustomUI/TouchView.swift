//
//  PressView.swift
//  ProjectSense
//
//  Created by Roman on 11/26/16.
//  Copyright © 2016 Kevin Jiang. All rights reserved.
//

import UIKit

protocol TouchViewDelegte: NSObjectProtocol {
    func touchViewDidBeginTouch(_ touchView: TouchView)
    func touchViewDidEndTouch(_ touchView: TouchView)
}

class TouchView: UIView {
    weak var delegate: TouchViewDelegte? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Touch Up/Down
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.touchViewDidBeginTouch(self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.delegate?.touchViewDidEndTouch(self)
    }

}
