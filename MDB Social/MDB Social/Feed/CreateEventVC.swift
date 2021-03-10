//
//  CreateEventVC.swift
//  MDB Social
//
//  Created by Jennessa Ma on 3/9/21.
//

import Foundation
import NotificationBannerSwift

class CreateEventVC: UIViewController {
    
    private let nameEventTextField: AuthTextField = {
        let tf = AuthTextField(title: "Name:")
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let eventDescriptionField: AuthTextField = {
        let tf = AuthTextField(title: "Description:")
        
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    
    private let createEventButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let dataPicker: UIDatePicker = UIDatePicker()
    
    private var bannerQueue = NotificationBannerQueue(maxBannersOnScreenSimultaneously: 1)
    
    override func viewDidLoad() {
        view.addSubview(createEventButton)
        createEventButton.addTarget(self, action: #selector(didTapCreateEvent(_:)), for: .touchUpInside)
    }
    
    @objc func didTapCreateEvent(_ sender: UIButton) {
        guard let name = nameEventTextField.text, name != "" else {
            showErrorBanner(withTitle: "Missing event name",
                            subtitle: "Please provide an event name")
            return
        }
        
        guard let desc = eventDescriptionField.text, desc != "" else {
            showErrorBanner(withTitle: "Missing event description",
                            subtitle: "Please provide an event description")
            return
        }
    }
    
    private func showErrorBanner(withTitle title: String, subtitle: String? = nil) {
        guard bannerQueue.numberOfBanners == 0 else { return }
        let banner = FloatingNotificationBanner(title: title, subtitle: subtitle,
                                                titleFont: .systemFont(ofSize: 17, weight: .medium),
                                                subtitleFont: subtitle != nil ?
                                                    .systemFont(ofSize: 14, weight: .regular) : nil,
                                                style: .warning)
        
        banner.show(bannerPosition: .top,
                    queue: bannerQueue,
                    edgeInsets: UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 15),
                    cornerRadius: 10,
                    shadowColor: .primaryText,
                    shadowOpacity: 0.3,
                    shadowBlurRadius: 10)
    }
}
