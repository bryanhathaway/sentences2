//
//  LayoutEngine.swift
//  Boxes
//
//  Created by Bryan Hathaway on 3/10/18.
//  Copyright © 2018 Bryan Hathaway. All rights reserved.
//

import Foundation
import UIKit

class LayoutEngine {
    let canvas: UIView
    let lineSpacing: CGFloat
    private var boxHeight: CGFloat = 0.0

    init(canvas: UIView, lineSpacing: CGFloat = 12.0) {
        self.canvas = canvas
        self.lineSpacing = lineSpacing
    }

    /// Distributes provided views to be adjacent to one another, left-to-right and top-to-bottom within the canvas' bounds.
    func distribute(views: [UIView]) {
        let horizontalPadding: CGFloat = 0.0
        let minimumX: CGFloat = 0.0
        let minimumY: CGFloat = lineSpacing / 2.0

        var previousView: UIView?
        views.enumerated().forEach { (index, view) in
            var origin = CGPoint(x: minimumX, y: minimumY)

            if let lastFrame = previousView?.frame {
                origin.x = lastFrame.maxX + horizontalPadding
                origin.y = lastFrame.origin.y

                if origin.x + view.frame.size.width > canvas.bounds.size.width - minimumX {
                    origin.x = minimumX
                    origin.y += lastFrame.size.height + lineSpacing
                }
            }
            view.frame.origin = origin
            previousView = view
        }
        boxHeight = previousView?.frame.size.height ?? 0.0
    }

    /// Moves all provided views to a random position in a word-adajacent paragraph style.
    func shuffle(views: [UIView]) {
        let maximumX: CGFloat = canvas.bounds.size.width
        let maximumY: CGFloat = canvas.bounds.size.height - lineSpacing / 2.0
        let horizontalSpacing: CGFloat = 2.0

        var previousView: UIView?
        views.shuffled().enumerated().forEach { (index, view) in
            var origin = CGPoint(x: maximumX - view.frame.size.width,
                                 y: maximumY - view.frame.size.height)
            if let lastFrame = previousView?.frame {
                origin.y = lastFrame.origin.y

                let possibleX = lastFrame.origin.x - view.frame.size.width - horizontalSpacing
                if possibleX >= 0 {
                    origin.x = possibleX
                } else {
                    origin.y -= lineSpacing + view.frame.size.height
                }
            }
            let options = TimingOptions(duration: Double.random(in: 0.8..<1.0),
                                        delay: 0.0,
                                        damping: CGFloat.random(in: 0.5..<0.7),
                                        spring: CGFloat.random(in: 0.4..<0.6))
            view.animateOrigin(to: origin, options: options)
            previousView = view
        }
    }

    /// Snaps a view with animation to its nearest line, making it center-aligned to other views in its line.
    func snap(view: UIView, completion: ((Bool) -> ())? = nil) {
        let lineHeight = boxHeight + lineSpacing

        // NearestRow will result to the origin.y of the closest row.
        var nearestRow = (view.center.y - boxHeight / 2.0).rounded(to: lineHeight)

        // Prevent vertical out of bounds
        nearestRow = max(nearestRow, 0)
        nearestRow = min(((canvas.bounds.size.height / lineHeight) - 1) * lineHeight, nearestRow)

        // Have to convert the origin.y to a center.y value.
        var newCenter = view.center
        newCenter.y = nearestRow + lineHeight / 2.0

        // Prevent horizontal out of bounds
        newCenter.x = max(newCenter.x, 0)
        newCenter.x = min(newCenter.x, canvas.bounds.size.width)

        view.animateCenter(to: newCenter, completion: completion)
    }

    /// Determins if the provided view intersects with the frame of any other view managed by the engine.
    func viewHasCollison(_ view: UIView) -> Bool {
        for otherView in canvas.subviews {
            guard otherView != view else { continue }
            if view.frame.intersects(otherView.frame) {
                return true
            }
        }

        return false
    }
}
