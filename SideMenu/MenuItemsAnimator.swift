//
//  Copyright © 2014 Yalantis
//  Licensed under the MIT license: http://opensource.org/licenses/MIT
//  Latest version can be found at http://github.com/yalantis/Side-Menu.iOS
//

import UIKit

private func TransformForRotatingLayer(layer: CALayer, angle: CGFloat, position: MenuPosition) -> CATransform3D {
    let offset = position == .Left ? layer.bounds.width / 2 : -layer.bounds.width / 2

    var transform = CATransform3DIdentity
    transform.m34 = -0.002
    transform = CATransform3DTranslate(transform, -offset, 0, 0)
    transform = CATransform3DRotate(transform, angle, 0, 1, 0)
    transform = CATransform3DTranslate(transform, offset, 0, 0)
    return transform
}

class MenuItemsAnimator {
    var completion: () -> Void = {}
    var duration: CFTimeInterval = 0

    private let layers: [CALayer]
    private let startAngle: CGFloat
    private let endAngle: CGFloat
    private let position: MenuPosition

    init(views: [UIView], startAngle: CGFloat, endAngle: CGFloat, position: MenuPosition) {
        self.layers = views.map { $0.layer }
        self.startAngle = startAngle
        self.endAngle = endAngle
        self.position = position
    }

    func start() {
        let count = Double(layers.count)
        let duration = self.duration * count / (4 * count - 3)
        for (index, layer) in layers.enumerate() {
            layer.transform = TransformForRotatingLayer(layer, angle: startAngle, position: position)

            let delay = 3 * duration * Double(index) / count
            UIView.animateWithDuration(duration, delay: delay, options: .CurveEaseIn, animations: {
                layer.transform = TransformForRotatingLayer(layer, angle: self.endAngle, position: self.position)
            }, completion: nil)
        }

        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(self.duration * Double(NSEC_PER_SEC)))
        dispatch_after(delay, dispatch_get_main_queue()) {
            self.completion()
        }
    }
}
