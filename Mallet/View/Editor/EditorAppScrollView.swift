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

    private let maxInsets: UIEdgeInsets

    @State private var contentPos: CGPoint = .zero

    init(scale: Binding<CGFloat>, offset: Binding<CGPoint>, scrollViewSize: CGSize, contentSize: CGSize, maxInsets: UIEdgeInsets = .zero, content: @escaping () -> Content) {

        self._scale = scale

        self._offset = offset

        self.content = content

        self.hosting = UIHostingController(rootView: content())

        self.scrollView = UIScrollView()

        self.scrollViewSize = scrollViewSize

        self.contentSize = contentSize

        self.maxInsets = maxInsets

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        scrollView.frame = CGRect(origin: CGPoint.zero, size: scrollViewSize)
        scrollView.contentSize = contentSize
        scrollView.maximumZoomScale = 2.0
        scrollView.minimumZoomScale = 0.7
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never

        hosting.view.frame = CGRect(origin: .zero, size: contentSize)

        scrollView.addSubview(hosting.view)
        view.addSubview(scrollView)

        scrollView.zoomScale = scale

        hosting.didMove(toParent: self)

        updateScrollInset()
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return hosting.view
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateScrollInset()
        scale = scrollView.zoomScale
        offset = scrollView.contentOffset
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateScrollInset()
        offset = scrollView.contentOffset
    }

    private func updateScrollInset() {
        let widthInset = max((scrollView.frame.width - hosting.view.frame.width) / 2, 0)
        let heightInset = max((scrollView.frame.height - hosting.view.frame.height) / 2, 0)

        let topInset = max(heightInset, maxInsets.top)
        let leftInset = max(widthInset, maxInsets.left)
        let bottomInset = max(heightInset, maxInsets.bottom)
        let rightInset = max(widthInset, maxInsets.right)

        scrollView.contentInset = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
    }
}

struct EditorAppScrollView<Content: View>: UIViewControllerRepresentable {

    @Binding var scale: CGFloat

    @Binding var offset: CGPoint

    let scrollViewSize: CGSize

    let contentSize: CGSize

    let maxInsets: UIEdgeInsets

    let content: () -> Content

    init(scale: Binding<CGFloat>, offset: Binding<CGPoint>, scrollViewSize: CGSize, contentSize: CGSize, maxInsets: UIEdgeInsets = .zero, content: @escaping () -> Content) {
        self._scale = scale

        self._offset = offset

        self.scrollViewSize = scrollViewSize

        self.contentSize = contentSize

        self.maxInsets = maxInsets

        self.content = content
    }

    func makeUIViewController(context: Context) -> EditorAppScrollViewController<Content> {
        return EditorAppScrollViewController(scale: $scale, offset: $offset, scrollViewSize: scrollViewSize, contentSize: contentSize, maxInsets: maxInsets) {
            self.content()
        }
    }

    func updateUIViewController(_ uiViewController: EditorAppScrollViewController<Content>, context: Context) {
    }
}
