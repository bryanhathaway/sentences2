//
//  FolderCreatorViewController.swift
//  Boxes
//
//  Created by Bryan Hathaway on 12/10/18.
//  Copyright © 2018 Bryan Hathaway. All rights reserved.
//

import Foundation
import UIKit

class FolderCreatorViewController: BlurredBackgroundViewController {
    private var folder: Folder
    private let folderView = FolderCreatorView()
    private let paintButton = UIButton(type: .custom)

    var onCancel: (() -> ())?
    var completion: ((Folder) -> ())?

    init(folder: Folder) {
        self.folder = folder
        super.init(nibName: nil, bundle: nil)

        title = "Create Folder"
        backgroundImage = #imageLiteral(resourceName: "aurora3")

        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        navigationItem.leftBarButtonItem = cancelItem

        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        navigationItem.rightBarButtonItem = doneItem
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        folderView.translatesAutoresizingMaskIntoConstraints = false
        folderView.titleTextField.text = folder.title
        folderView.sideColor = folder.color
        view.addSubview(folderView)

        paintButton.setBackgroundImage(#imageLiteral(resourceName: "button_paint").withRenderingMode(.alwaysTemplate), for: .normal)
        paintButton.tintColor = folder.color
        paintButton.translatesAutoresizingMaskIntoConstraints = false
        paintButton.addTarget(self, action: #selector(paintTapped(_:)), for: .touchUpInside)
        view.addSubview(paintButton)


        let leadingConstraint = folderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0)
        let trailingConstraint = folderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0)
        leadingConstraint.priority = .defaultHigh
        trailingConstraint.priority = .defaultHigh
        NSLayoutConstraint.activate([
            folderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32.0),
            folderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            folderView.widthAnchor.constraint(lessThanOrEqualToConstant: 360.0),
            leadingConstraint,
            trailingConstraint,
            folderView.heightAnchor.constraint(equalToConstant: 100.0),

            paintButton.topAnchor.constraint(equalTo: folderView.bottomAnchor, constant: 8.0),
            paintButton.leadingAnchor.constraint(equalTo: folderView.leadingAnchor),
            paintButton.heightAnchor.constraint(equalToConstant: 22.0),
            paintButton.widthAnchor.constraint(equalTo: paintButton.heightAnchor)
            ])
    }

    @objc func cancelTapped() {
        folderView.endEditing(true)
        navigationController?.dismiss(animated: true)
        onCancel?()
    }

    @objc func doneTapped() {
        guard let title = folderView.titleTextField.text, title.count > 0 else { return }
        folderView.endEditing(true)

        folder.title = title
        folder.color = folderView.sideColor

        completion?(folder)
        navigationController?.dismiss(animated: true, completion: nil)
    }

    @objc func paintTapped(_ sender: UIButton) {
        let controller = ColorPickerPopover()
        guard let popover = controller.popoverPresentationController else { return }
        popover.delegate = self
        popover.sourceRect = sender.bounds
        popover.sourceView = sender

        controller.onColorPicked = { [weak self, weak controller] color in
            self?.folderView.sideColor = color
            self?.paintButton.tintColor = color
            controller?.dismiss(animated: true, completion: nil)
        }

        present(controller, animated: true, completion: nil)
    }
}

extension FolderCreatorViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
