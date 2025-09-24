//
//  SubviewAttachingTextView.swift
//  SubviewAttachingTextView
//
//  Created by Vlas Voloshin on 29/1/17.
//  Copyright © 2017 Vlas Voloshin. All rights reserved.
//

import UIKit

/**
 Simple subclass of UITextView that embeds a SubviewAttachingTextViewBehavior. A similar implementation can be used in custom subclasses.
 */
@objc(VVSubviewAttachingTextView)
open class SubviewAttachingTextView: UITextView {

    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    deinit {
        disconnectBehavior()
    }

    private let attachmentBehavior = SubviewAttachingTextViewBehavior()
    private var behaviorConnected = false

    open override func didMoveToWindow() {
        super.didMoveToWindow()
        if window != nil {
            connectBehaviorIfNeeded()
        } else {
            disconnectBehavior()
        }
    }

    public func connectBehaviorIfNeeded() {
        guard !behaviorConnected else { return }

        attachmentBehavior.textView = self
        layoutManager.delegate = attachmentBehavior
        textStorage.delegate = attachmentBehavior
        behaviorConnected = true
    }

    public func disconnectBehavior() {
        guard behaviorConnected else { return }
        if layoutManager.delegate === attachmentBehavior {
            layoutManager.delegate = nil
        }

        if textStorage.delegate === attachmentBehavior {
            textStorage.delegate = nil
        }

        attachmentBehavior.textView = nil
        behaviorConnected = false
    }

    open override var textContainerInset: UIEdgeInsets {
        didSet {
            // Text container insets are used to convert coordinates between the text container and text view, so a change to these insets must trigger a layout update
            self.attachmentBehavior.layoutAttachedSubviews()
        }
    }

}
