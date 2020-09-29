//
//  EditorAppScrollView.swift
//  Mallet
//  
//  Created by Katsu Matsuda on 2020/03/05.
//  Copyright (c) 2020 Katsu Matsuda. All rights reserved.
//

import SwiftUI

class EditorAppScrollViewController<Content: View>: UIViewController, UIScrollViewDelegate {

    @Binding var scale: CGFloat

    @Binding var offset: CGPoint

    private let content: () -> Content

    private let hosting: UIHostingController<Content>

    private let scrollView: UIScrollView

    private var scrollViewSize: CGSize

    private var contentSize: CGSize

    private let contentPadding: CGFloat

    private var maxInsets: UIEdgeInsets

    private let initialOffset: CGPoint

    @State private var contentPos: CGPoint = .zero

    init(scale: Binding<CGFloat>,
         offset: Binding<CGPoint>,
         scrollViewSize: CGSize,
         contentSize: CGSize,
         contentPadding: CGFloat,
         maxInsets: UIEdgeInsets = .zero,
         initialOffset: CGPoint = .zero,
         content: @escaping () -> Content) {

        self._scale = scale

        self._offset = offset

        self.content = content

        hosting = UIHostingController(rootView: content())

        scrollView = UIScrollView()

        self.scrollViewSize = scrollViewSize

        self.contentSize = contentSize

        self.contentPadding = contentPadding

        self.maxInsets = maxInsets

        self.initialOffset = initialOffset

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        scrollView.backgroundColor = .clear
        scrollView.maximumZoomScale = 2.0
        scrollView.minimumZoomScale = 0.8
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never

        hosting.view.backgroundColor = .clear

        scrollView.addSubview(hosting.view)
        view.addSubview(scrollView)

        update(scrollViewSize: scrollViewSize, contentSize: contentSize, maxInsets: maxInsets, swiftUIView: content)

        scrollView.zoomScale = scale

        hosting.didMove(toParent: self)

        updateScrollInset()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        scrollViewDidZoom(scrollView)
    }

    func update(scrollViewSize: CGSize, contentSize: CGSize, maxInsets: UIEdgeInsets, swiftUIView: @escaping () -> Content) {
        if contentSize == self.contentSize || contentSize == .zero {
            return
        }

        hosting.rootView = swiftUIView()

        self.scrollViewSize = scrollViewSize
        self.contentSize = contentSize
        self.maxInsets = maxInsets

        scrollView.zoomScale = 1

        scrollView.frame = CGRect(origin: .zero, size: scrollViewSize)

        hosting.view.frame = CGRect(origin: .zero, size: CGSize(width: contentSize.width + contentPadding * 2, height: contentSize.height + contentPadding * 2))

        scrollView.contentSize = contentSize
        scrollView.zoomScale = scale

        updateScrollInset()
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        hosting.view
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateScrollInset()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateScrollInset()
    }

    func setOffset() {
        offset = CGPoint(x: scrollView.contentOffset.x - contentPadding * scrollView.zoomScale, y: scrollView.contentOffset.y - contentPadding * scrollView.zoomScale)
    }

    private func updateScrollInset() {
        let widthInset = max((scrollView.frame.width - maxInsets.left - maxInsets.right - contentSize.width * scrollView.zoomScale) / 2, 0)
        let heightInset = max((scrollView.frame.height - maxInsets.top - maxInsets.bottom - contentSize.height * scrollView.zoomScale) / 2, 0)

        var topInset = -contentPadding * scrollView.zoomScale
        var leftInset = -contentPadding * scrollView.zoomScale
        var bottomInset = -contentPadding * scrollView.zoomScale
        var rightInset = -contentPadding * scrollView.zoomScale

        if widthInset == 0 {
            leftInset += maxInsets.left
            rightInset += maxInsets.right
        } else {
            leftInset += widthInset + maxInsets.left - initialOffset.x / 2
            rightInset += widthInset + maxInsets.right + initialOffset.x / 2
        }

        if heightInset == 0 {
            topInset += maxInsets.top
            bottomInset += maxInsets.bottom
        } else {
            topInset += heightInset + maxInsets.top - initialOffset.y / 2
            bottomInset += heightInset + maxInsets.bottom + initialOffset.y / 2
        }

        scrollView.contentInset = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)

        scale = scrollView.zoomScale
        setOffset()
    }
}

struct EditorAppScrollView<Content: View>: UIViewControllerRepresentable {

    @Binding var scale: CGFloat

    @Binding var offset: CGPoint

    var scrollViewSize: CGSize

    var contentSize: CGSize

    let contentPadding: CGFloat

    var maxInsets: UIEdgeInsets

    let initialOffset: CGPoint

    let content: () -> Content

    init(scale: Binding<CGFloat>,
         offset: Binding<CGPoint>,
         scrollViewSize: CGSize,
         contentSize: CGSize,
         contentPadding: CGFloat,
         maxInsets: UIEdgeInsets = .zero,
         initialOffset: CGPoint = .zero,
         content: @escaping () -> Content) {
        self._scale = scale

        self._offset = offset

        self.scrollViewSize = scrollViewSize

        self.contentSize = contentSize

        self.contentPadding = contentPadding

        self.maxInsets = maxInsets

        self.initialOffset = initialOffset

        self.content = content
    }

    func makeUIViewController(context: Context) -> EditorAppScrollViewController<Content> {
        EditorAppScrollViewController(scale: $scale,
                                      offset: $offset,
                                      scrollViewSize: scrollViewSize,
                                      contentSize: contentSize,
                                      contentPadding: contentPadding,
                                      maxInsets: maxInsets,
                                      initialOffset: initialOffset) {
            content()
        }
    }

    func updateUIViewController(_ uiViewController: EditorAppScrollViewController<Content>, context: Context) {
        uiViewController.update(scrollViewSize: scrollViewSize, contentSize: contentSize, maxInsets: maxInsets, swiftUIView: content)
    }
}
