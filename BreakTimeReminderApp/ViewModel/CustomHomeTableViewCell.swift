//
//  CustomHomeTableViewCell.swift
//  BreakTimeReminderApp
//
//  Created by hanif hussain on 23/08/2023.
//

import UIKit

struct savedTimers: Codable {
    var title: String!
    var repeatDay: [Int]!
    var date: Date!
    var notificationIdentifier: [String]!
}

class CustomHomeTableViewCell: UITableViewCell {
    
    
    // Create image attachment for our timer object
    let imageAttachment = NSTextAttachment(image: UIImage(systemName: "timer")!)

    var backgroundCard: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.backgroundColor = UIColor.secondarySystemBackground
        view.clipsToBounds = true
        
        // set masks to bounds to false to avoid the shadow from being clipped to the corner radius
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = false
        
        // apply a shadow
        view.layer.shadowRadius = 8.0
        view.layer.shadowOpacity = 0.10
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        return view
    }()
    
    var title: UILabel = {
       let title = UILabel()
        title.adjustsFontSizeToFitWidth = true
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.systemFont(ofSize: 20, weight: .thin)
        return title
    }()
    
    var start: UILabel = {
        let start = UILabel()
        start.adjustsFontSizeToFitWidth = true
        start.translatesAutoresizingMaskIntoConstraints = false
        start.font = UIFont.systemFont(ofSize: 13)
        start.textColor = .systemGray
        return start
        
    }()
    
    var repeatDay: UILabel = {
       let day = UILabel()
        day.adjustsFontSizeToFitWidth = true
        day.translatesAutoresizingMaskIntoConstraints = false
        day.font = UIFont.boldSystemFont(ofSize: 10)
        return day
    }()
    
    var manageTimerImage: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "ellipsis")?.imageWithoutBaseline())
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.isUserInteractionEnabled = true
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // apply rounded corner to contentView
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        // improve scrolling perfomance with an explicit ShadowPath
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 10).cgPath
        
        addSubview(backgroundCard)
        addSubview(title)
        addSubview(start)
        addSubview(repeatDay)
        addSubview(manageTimerImage)
        backgroundCardConstraints()
        titleConstraints()
        repeatDayConstraints()
        manageTimerImageConstraints()
        startConstraints()
        
        
    }
    
    // add constraints for each subview
    
    fileprivate func backgroundCardConstraints() {
        NSLayoutConstraint.activate([
            backgroundCard.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            backgroundCard.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            backgroundCard.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            backgroundCard.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
            
        ])
    }
    
    fileprivate func titleConstraints() {
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: backgroundCard.topAnchor, constant: 14),
            title.heightAnchor.constraint(equalToConstant: 25),
            title.leadingAnchor.constraint(equalTo: backgroundCard.leadingAnchor, constant: 20)
        ])
    }
    
    fileprivate func repeatDayConstraints() {
        NSLayoutConstraint.activate([
            repeatDay.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10),
            repeatDay.heightAnchor.constraint(equalToConstant: 25),
            repeatDay.leadingAnchor.constraint(equalTo: backgroundCard.leadingAnchor, constant: 21)
        ])
    }
    
    fileprivate func startConstraints() {
        NSLayoutConstraint.activate([
            start.topAnchor.constraint(equalTo: backgroundCard.topAnchor, constant: 50),
            start.leadingAnchor.constraint(greaterThanOrEqualToSystemSpacingAfter: backgroundCard.leadingAnchor, multiplier: 1),
            start.trailingAnchor.constraint(equalTo: backgroundCard.trailingAnchor, constant: -5)

        ])
    }
    
    
    fileprivate func manageTimerImageConstraints() {
        NSLayoutConstraint.activate([
            manageTimerImage.topAnchor.constraint(equalTo: backgroundCard.topAnchor, constant: 14),
            manageTimerImage.leadingAnchor.constraint(greaterThanOrEqualToSystemSpacingAfter: backgroundCard.leadingAnchor, multiplier: 1),
            manageTimerImage.trailingAnchor.constraint(equalTo: backgroundCard.trailingAnchor, constant: -10),
        
        ])
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
    
    func set(result: savedTimers) {
        // Create string with attachment
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        // Initialize mutable string
        let completeText = NSMutableAttributedString(string: "")
        // Add image to mutable string
        completeText.append(attachmentString)
        // Add your text to mutable string
        let textAfterIcon = NSAttributedString(string: " \(result.title!)")
        completeText.append(textAfterIcon)
        title.attributedText = completeText
        start.text = "Start"
        if let RepeatDay = result.repeatDay {
            repeatDay.text = "\(RepeatDay)"
        } else {
            repeatDay.text = "(\(result.date.formatted(date: .abbreviated, time: .omitted)))"
        }
        
        print(result.notificationIdentifier)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
