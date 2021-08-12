//
//  IdView.swift
//  InterviewPractice
//
//  Created by mac on 4/23/21.
//

import UIKit

public protocol IdViewDelegate: class {
    func idView(_ idView: IDView, wasTappedOn face: IDView.Face)
}

public class IDView: UIView {

    // MARK: Inspectables
    public var frontPlaceHolderImage: UIImage? {
        didSet {
            if face == .front && frontImage == nil {
                idImageView.image = frontPlaceHolderImage
            }
        }
    }
    public var backPlaceHolderImage: UIImage? {
        didSet {
            if face == .back && backImage == nil {
                idImageView.image = backPlaceHolderImage
            }
        }
    }

    // MARK: Properties
    public weak var delegate: IdViewDelegate?
    private var isFront = true
    private var isFlipping = false
    private var frontImage: UIImage?
    private var backImage: UIImage?
    private var currentImage: UIImage? {
        face == .front ? frontImage : backImage
    }
    private var otherImage: UIImage? {
        image(for: face.otherFace)
    }

    // MARK: Views
    private lazy var idImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    private func setup() {
        addIDViewImageViewToHierarchy()
        addTapGestureToView()
    }
    private func addIDViewImageViewToHierarchy() {
        addSubview(idImageView)
        idImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        idImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        idImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        idImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        idImageView.layer.masksToBounds = true
    }
    private func addTapGestureToView() {
        idImageView.isUserInteractionEnabled = true
        idImageView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(cameraImageViewTapGestureHandler)
            )
        )
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        idImageView.layer.cornerRadius = layer.cornerRadius
    }

    @objc func cameraImageViewTapGestureHandler() {
        delegate?.idView(self, wasTappedOn: face)
    }
}

public extension IDView {
    var face: IDView.Face {
        isFront ? .front : .back
    }
    func image(for face: IDView.Face) -> UIImage? {
        face == .front ? frontImage ?? frontPlaceHolderImage : backImage ?? backPlaceHolderImage
    }
}

public extension IDView {
    func set(image: UIImage?, flip: Bool) {
        face == .front ? (frontImage = image) : (backImage = image)
        UIView.transition(
            with: idImageView,
            duration: 0.5,
            options: .transitionCrossDissolve,
            animations: {
                self.idImageView.image = self.image(for: self.face)
            },
            completion: { _ in
                if flip {
                    self.flip()
                }
            }
        )
    }

    func flip() {
        guard !isFlipping else { return }

        self.isFlipping = true
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.2
        ) {
            let transitionOptions: UIView.AnimationOptions = [
                .transitionFlipFromRight,
                .showHideTransitionViews
            ]

            UIView.transition(
                with: self.idImageView,
                duration: 1.0,
                options: transitionOptions,
                animations: {
                    self.idImageView.image = self.otherImage
                    if self.otherImage == nil {
                    }
                    self.isFront.toggle()
                }, completion: { (_) in
                    self.isFlipping = false
                }
            )

        }
    }
}

public extension IDView {
    enum Face {
        case front
        case back

        fileprivate var otherFace: Self {
            self == .front ? .back : .front
        }
    }
}
