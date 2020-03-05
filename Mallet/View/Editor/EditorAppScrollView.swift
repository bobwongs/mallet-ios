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

    init(scale: Binding<CGFloat>, offset: Binding<CGPoint>, content: @escaping () -> Content) {
        self._scale = scale

        self._offset = offset

        self.content = content

        self.hosting = UIHostingController(rootView: content())

        self.scrollView = UIScrollView()

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                                        scrollView.topAnchor.constraint(equalTo: view.topAnchor),
                                        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
                                    ])

        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        scrollView.maximumZoomScale = 2.0
        scrollView.minimumZoomScale = 0.7
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never

        scrollView.addSubview(hosting.view)
        hosting.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                                        hosting.view.topAnchor.constraint(equalTo: scrollView.topAnchor),
                                        hosting.view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                                        hosting.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                                        hosting.view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
                                    ])
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
        offset = scrollView.contentOffset
    }

    private func updateScrollInset() {
        scrollView.contentInset = UIEdgeInsets(
            top: max((scrollView.frame.height - hosting.view.frame.height) / 2, 0),
            left: max((scrollView.frame.width - hosting.view.frame.width) / 2, 0),
            bottom: 0,
            right: 0
        )
    }
}

struct EditorAppScrollView<Content: View>: UIViewControllerRepresentable {

    @Binding var scale: CGFloat

    @Binding var offset: CGPoint

    let content: () -> Content

    init(scale: Binding<CGFloat>, offset: Binding<CGPoint>, content: @escaping () -> Content) {
        self._scale = scale

        self._offset = offset

        self.content = content
    }

    func makeUIViewController(context: Context) -> EditorAppScrollViewController<Content> {
        return EditorAppScrollViewController(scale: $scale, offset: $offset) {
            self.content()
        }
    }

    func updateUIViewController(_ uiViewController: EditorAppScrollViewController<Content>, context: Context) {
    }
}