//
//  SentenceConstructorViewController.swift
//  Boxes
//
//  Created by Bryan Hathaway on 4/10/18.
//  Copyright © 2018 Bryan Hathaway. All rights reserved.
//

import Foundation
import UIKit

class SentenceConstructorViewController: BlurredBackgroundViewController {
    private let reuseIdentifier = "Cell"

    var completion: ((Sentence) -> ())?

    private var sentence: Sentence
    private var collectionView: UICollectionView?

    init(sentence: Sentence) {
        self.sentence = sentence

        super.init(nibName: nil, bundle: nil)

        title = sentence.title
        backgroundImage = #imageLiteral(resourceName: "aurora2.jpg")
        blurStyle = .dark
        
        let saveItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveTapped))

        let helpItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_help"), style: .plain, target: self, action: #selector(helpTapped))
 
        navigationItem.rightBarButtonItems = [saveItem, helpItem]
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewLeftAlignedLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = 8.0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        collectionView.allowsMultipleSelection = true
        collectionView.dragInteractionEnabled = true
        collectionView.backgroundColor = .clear
        collectionView.register(BoxCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        view.addSubview(collectionView)
        self.collectionView = collectionView

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16.0),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16.0),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16.0),
            ])
    }

    @objc func saveTapped() {
        navigationController?.dismiss(animated: true, completion: nil)
        completion?(sentence)
    }

    @objc func helpTapped() {
        let message = "Tap two boxes to join them.\n\nTap, Hold, and Drag a box to rearrange the order.\n\nDouble tap a box for more options."
        let controller = UIAlertController(title: "Construction Tips", message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        present(controller, animated: true, completion: nil)
    }

    // MARK: - Cell Operations
    func showOptions(for cell: BoxCell) {

        collectionView?.indexPathsForSelectedItems?.forEach {
            collectionView?.deselectItem(at: $0, animated: false)
        }
        cell.stopWriggling()

        let controller = UIAlertController(title: cell.text, message: nil, preferredStyle: .actionSheet)
        let popover = controller.popoverPresentationController
        popover?.sourceRect = cell.bounds
        popover?.sourceView = cell

        let isUS = NSLocale.current.languageCode == "en_US"
        let title = "Change " + (isUS ? "Color" : "Colour")
        controller.addAction(UIAlertAction(title: title, style: .default, handler: { [weak self] action in
            self?.showColorPicker(for: cell)
        }))

        controller.addAction(UIAlertAction(title: "Split", style: .default, handler: { [weak self] action in
            self?.split(cell: cell)
        }))

        controller.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] action in
            self?.delete(cell: cell)
        }))

        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(controller, animated: true, completion: nil)
    }

    func showColorPicker(for cell: BoxCell) {
        guard let indexPath = collectionView?.indexPath(for: cell) else { return }

        let controller = ColorPickerPopover()
        let popover = controller.popoverPresentationController
        popover?.sourceRect = cell.bounds
        popover?.sourceView = cell
        popover?.delegate = self
        controller.onColorPicked = { [weak self] color in
            var phrase = self?.sentence.phrases[indexPath.row]
            phrase?.color = color
            cell.backgroundColor = color
        }
        present(controller, animated: true, completion: nil)
    }

    func split(cell: BoxCell) {
        guard let indexPath = collectionView?.indexPath(for: cell) else { return }

        let phrase = sentence.phrases[indexPath.row]
        let words = LanguageProcessor.words(from: phrase.value)
        let nonSpaces = words.filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }

        let newPhrases = nonSpaces.map { Phrase(value: $0) }
        sentence.phrases.remove(at: indexPath.row)
        sentence.phrases.insert(contentsOf: newPhrases, at: indexPath.row)

        let insertionPaths = newPhrases.enumerated().map { (index, _) in
            return IndexPath(row: indexPath.row + index, section: 0)
        }

        collectionView?.performBatchUpdates({
            collectionView?.deleteItems(at: [indexPath])
            collectionView?.insertItems(at: insertionPaths)
        }, completion: nil)
    }

    func delete(cell: BoxCell) {
        guard let indexPath = collectionView?.indexPath(for: cell) else { return }

        sentence.phrases.remove(at: indexPath.row)
        collectionView?.deleteItems(at: [indexPath])
    }
}

// MARK: - DataSource / Delegate

extension SentenceConstructorViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sentence.phrases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BoxCell

        let phrase = sentence.phrases[indexPath.row]
        cell.text = phrase.value
        cell.backgroundColor = phrase.color
        cell.onDoubleTap = { [weak self] cell in
            self?.showOptions(for: cell)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 45.0
        let phrase = sentence.phrases[indexPath.row]
        let width = phrase.value.width(withConstrainedHeight: height, font: Box.compactFont)
        return CGSize(width: width + 16.0, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let otherPath = collectionView.indexPathsForSelectedItems?.first(where: { $0 != indexPath }) {
            collectionView.indexPathsForSelectedItems?.forEach {
                collectionView.deselectItem(at: $0, animated: false)
            }

            let otherIsAfter = otherPath.row > indexPath.row
            let destination = otherIsAfter ? indexPath : otherPath
            let origin = otherIsAfter ? otherPath : indexPath
            combine(path: origin, into: destination, in: collectionView)

        } else {
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.startWiggle()
        }
    }

    func combine(path originPath: IndexPath, into destinationPath: IndexPath, in collectionView: UICollectionView) {
        let originPhrase = sentence.phrases[originPath.row]
        let destinationPhrase = sentence.phrases[destinationPath.row]

        destinationPhrase.value += " " + originPhrase.value
        sentence.phrases.remove(at: originPath.row)
        guard let newCell = collectionView.cellForItem(at: destinationPath) as? BoxCell else { return }
        newCell.stopWriggling()

        collectionView.performBatchUpdates({
            collectionView.deleteItems(at: [originPath])
            UIView.transition(with: newCell, duration: 0.1, options: [], animations: {
                newCell.text = destinationPhrase.value
                newCell.frame.size = newCell.intrinsicContentSize
            }, completion: nil)
        }, completion: nil)
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.stopWriggling()
    }
}

// MARK: - Drag and drop
extension SentenceConstructorViewController: UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let phrase = sentence.phrases[indexPath.row]
        let itemProvider = NSItemProvider(object: phrase.value as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = phrase

        return [dragItem]
    }

    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        let phrase = sentence.phrases[indexPath.row]
        let itemProvider = NSItemProvider(object: phrase.value as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = phrase
        return [dragItem]
    }

    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        guard session.localDragSession != nil else {
            return UICollectionViewDropProposal(operation: .forbidden)
        }

        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)

        }

        return UICollectionViewDropProposal(operation: .forbidden)

    }

    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let section = collectionView.numberOfSections - 1
            let row = collectionView.numberOfItems(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }

        switch coordinator.proposal.operation {
        case .move:
            let items = coordinator.items
            if items.count == 1, let item = items.first, let sourceIndexPath = item.sourceIndexPath
            {
                var dIndexPath = destinationIndexPath
                if dIndexPath.row >= collectionView.numberOfItems(inSection: 0)
                {
                    dIndexPath.row = collectionView.numberOfItems(inSection: 0) - 1
                }
                collectionView.performBatchUpdates({
                    self.sentence.phrases.remove(at: sourceIndexPath.row)
                    self.sentence.phrases.insert(item.dragItem.localObject as! Phrase, at: dIndexPath.row)
                    collectionView.deleteItems(at: [sourceIndexPath])
                    collectionView.insertItems(at: [dIndexPath])


                })
                coordinator.drop(item.dragItem, toItemAt: dIndexPath)
            }
            break

        default:
            return
        }
    }
}

// MARK: - Popover Handling

extension SentenceConstructorViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
