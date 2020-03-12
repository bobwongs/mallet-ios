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

    private let scrollViewSize: CGSize

    private let contentSize: CGSize

    private let contentPadding: CGFloat

    private let maxInsets: UIEdgeInsets

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

        self.hosting = UIHostingController(rootView: content())

        self.scrollView = UIScrollView()

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
        scrollView.frame = CGRect(origin: CGPoint.zero, size: scrollViewSize)
        scrollView.backgroundColor = .clear
        scrollView.maximumZoomScale = 2.0
        scrollView.minimumZoomScale = 0.8
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never

        hosting.view.frame = CGRect(origin: .zero, size: CGSize(width: contentSize.width + contentPadding * 2, height: contentSize.height + contentPadding * 2))
        hosting.view.backgroundColor = .clear

        scrollView.addSubview(hosting.view)
        view.addSubview(scrollView)

        scrollView.contentSize = CGSize(width: contentSize.width, height: contentSize.height)

        scrollView.zoomScale = scale

        hosting.didMove(toParent: self)

        updateScrollInset()

        scrollView.contentOffset.x += initialOffset.x * scrollView.zoomScale
        scrollView.contentOffset.y += initialOffset.y * scrollView.zoomScale

        setOffset(scrollView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        scrollViewDidZoom(scrollView)
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return hosting.view
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateScrollInset()
        scale = scrollView.zoomScale
        setOffset(scrollView)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateScrollInset()
        setOffset(scrollView)
    }

    func setOffset(_ scrollView: UIScrollView) {
        offset = CGPoint(x: scrollView.contentOffset.x - contentPadding * scrollView.zoomScale, y: scrollView.contentOffset.y - contentPadding * scrollView.zoomScale)
    }

    private func updateScrollInset() {
        let widthInset = max((scrollView.frame.width - contentSize.width * scrollView.zoomScale) / 2, 0)
        let heightInset = max((scrollView.frame.height - contentSize.height * scrollView.zoomScale) / 2, 0)

        let topInset = max(heightInset, maxInsets.top) - contentPadding * scrollView.zoomScale
        let leftInset = max(widthInset, maxInsets.left) - contentPadding * scrollView.zoomScale
        let bottomInset = max(heightInset, maxInsets.bottom) - contentPadding * scrollView.zoomScale
        let rightInset = max(widthInset, maxInsets.right) - contentPadding * scrollView.zoomScale

        scrollView.contentInset = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
    }
}

struct EditorAppScrollView<Content: View>: UIViewControllerRepresentable {

    @Binding var scale: CGFloat

    @Binding var offset: CGPoint

    let scrollViewSize: CGSize

    let contentSize: CGSize

    let contentPadding: CGFloat

    let maxInsets: UIEdgeInsets

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
        return EditorAppScrollViewController(scale: $scale,
                                             offset: $offset,
                                             scrollViewSize: scrollViewSize,
                                             contentSize: contentSize,
                                             contentPadding: contentPadding,
                                             maxInsets: maxInsets,
                                             initialOffset: initialOffset) {
            self.content()
        }
    }

    func updateUIViewController(_ uiViewController: EditorAppScrollViewController<Content>, context: Context) {
    }
}
