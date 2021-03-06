//
//  CardView.swift
//  The 2 Become 1
//
//  Created by Ramon Geronimo on 11/27/18.
//  Copyright © 2018 Ramon Geronimo. All rights reserved.
//

import UIKit
import SDWebImage

protocol CardViewDelegate {
    func didTapMoreInfo(cardViewModel: CardViewModel)
}

class CardView: UIView {
    
    var delegate: CardViewDelegate?
    
    var cardViewModel: CardViewModel! {
        didSet {
            let imageName = cardViewModel.imageUrls.first ?? ""
//            imageView.image = UIImage(named: imageName)
            if let url = URL(string: imageName){
                imageView.sd_setImage(with: url)
            }
            
            
            infomartionLabel.attributedText = cardViewModel.attributedString
            infomartionLabel.textAlignment = cardViewModel.textAlignment
            
            (0..<cardViewModel.imageUrls.count).forEach { (_) in
                let barView = UIView()
                barView.backgroundColor = barDeselectedColor
                barsStackView.addArrangedSubview(barView)
            }
            barsStackView.arrangedSubviews.first?.backgroundColor = .white
            
            setupImageIndexObserver()
        }
    }
    
    fileprivate func setupImageIndexObserver(){
        cardViewModel.imageIndexObserver = {[weak self](index, imageUrl) in
            if let url = URL(string: imageUrl ?? ""){
                self?.imageView.sd_setImage(with: url)
            }
            
            self?.barsStackView.arrangedSubviews.forEach({ (v) in
                v.backgroundColor = self?.barDeselectedColor
            })
            self?.barsStackView.arrangedSubviews[index].backgroundColor = .white
        }
    }
    
    // encapsulation
    fileprivate let imageView = UIImageView(image: #imageLiteral(resourceName: "pronovias-romantic-sheath-wedding-dress-33614074"))
    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate let infomartionLabel = UILabel()
    
    // Configurations
    fileprivate let threshold: CGFloat = 80
    

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    fileprivate let barDeselectedColor = UIColor(white: 0, alpha: 0.1)
    @objc fileprivate func handleTap(gesture: UITapGestureRecognizer){
        let tapLocation = gesture.location(in: nil)
        let shouldAdvanceNextPhoto = tapLocation.x > frame.width / 2 ? true : false
        if shouldAdvanceNextPhoto {
            cardViewModel.advanceToNextPhoto()
        } else {
            cardViewModel.goToPreviousPhoto()
        }
    }
    
    fileprivate let moreInfoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "info_icon").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleMoreInfo), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleMoreInfo(){
        delegate?.didTapMoreInfo(cardViewModel: self.cardViewModel)
        
    }
    
    fileprivate func setupLayout() {
        //custom drawing code
        layer.cornerRadius = 10
        clipsToBounds = true
        
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        imageView.fillSuperview()
        
        
        setupBarsStackView()
        
        // add a gradient layer
        setupGradientLayer()
        
        addSubview(infomartionLabel)
        infomartionLabel.anchorForSwipe(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
        
        infomartionLabel.textColor = .white
        infomartionLabel.numberOfLines = 0
        
        addSubview(moreInfoButton)
        moreInfoButton.anchorForSwipe(top: nil, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 16, right: 16), size: .init(width: 44, height: 44))
    }
    
    fileprivate let barsStackView = UIStackView()
    
    
    fileprivate func setupBarsStackView(){
        addSubview(barsStackView)
        barsStackView.anchorForSwipe(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 4))
        
        barsStackView.spacing = 4
        barsStackView.distribution = .fillEqually
        
    }
    
    fileprivate func setupGradientLayer(){
        // Gradient
        
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor(white: 0, alpha: 0.2).cgColor]
        gradientLayer.locations = [0.5, 1.1]
        
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        // Know what cardview frame will be
        gradientLayer.frame = self.frame
    }
    
    
    
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {
        
        switch gesture.state {
        case .began:
            superview?.subviews.forEach({ (subview) in
                subview.layer.removeAllAnimations()
            })
        case .changed:
            handleChanged(gesture)
        case .ended:
            handleEnded(gesture)
        default:
            ()
        }
    }
    
    fileprivate func handleChanged(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)
        // rotation
        
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 180
        
        
        let rotationalTransformation = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTransformation.translatedBy(x: translation.x, y: translation.y)

    }
    
    fileprivate func handleEnded(_ gesture: UIPanGestureRecognizer) {
        let translationDirection: CGFloat = gesture.translation(in: nil).x > 0 ? 1 :  -1
        let shouldDismissCard = abs(gesture.translation(in: nil).x) > threshold
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            if shouldDismissCard {
                self.frame = CGRect(x: 1000 * translationDirection, y: 0, width: self.frame.width, height: self.frame.height)
                
            } else {
                self.transform = .identity
            }
            
        }) { (_) in

            self.transform = .identity
            if shouldDismissCard {
                self.removeFromSuperview()
            }
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
