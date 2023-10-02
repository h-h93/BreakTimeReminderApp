//
//  CustomHomeTableViewCell.swift
//  BreakTimeReminderApp
//
//  Created by hanif hussain on 23/08/2023.
//

import UIKit

struct savedTimers: Codable {
    var uuid: String!
    var title: String!
    var repeatDay: [String]!
    var weekDay: [Int]!
    var date: Date!
    var timeOfDay: Date!
    var notificationIdentifier: [String]!
    var timeDuration: TimeInterval!
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
        view.layer.shadowRadius = 9.0
        view.layer.shadowOpacity = 1
        view.layer.shadowColor = UIColor.secondaryLabel.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        return view
    }()
    
    var title: UILabel = {
       let title = UILabel()
        title.adjustsFontSizeToFitWidth = true
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.systemFont(ofSize: 20, weight: .thin)
        title.lineBreakMode = NSLineBreakMode.byWordWrapping
        title.numberOfLines = 0
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
    
    var repeatDayLabel: UILabel = {
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
    
    var manageTimerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        view.backgroundColor = .clear
        return view
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
        addSubview(repeatDayLabel)
        manageTimerView.addSubview(manageTimerImage)
        addSubview(manageTimerView)
        backgroundCardConstraints()
        titleConstraints()
        repeatDayConstraints()
        manageTimerImageConstraints()
        startConstraints()
        
        
    }
    
    // add constraints for each subview
    
    fileprivate func backgroundCardConstraints() {
        NSLayoutConstraint.activate([
            backgroundCard.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            backgroundCard.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            backgroundCard.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            backgroundCard.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
            
        ])
    }
    
    fileprivate func titleConstraints() {
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: backgroundCard.topAnchor, constant: 14),
            title.leadingAnchor.constraint(equalTo: backgroundCard.leadingAnchor, constant: 20),
            title.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),
            title.trailingAnchor.constraint(equalTo: backgroundCard.trailingAnchor, constant: -8)
        ])
    }
    
    fileprivate func repeatDayConstraints() {
        NSLayoutConstraint.activate([
            repeatDayLabel.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 45),
            repeatDayLabel.heightAnchor.constraint(equalToConstant: 25),
            repeatDayLabel.leadingAnchor.constraint(equalTo: backgroundCard.leadingAnchor, constant: 21)
        ])
    }
    
    fileprivate func startConstraints() {
        NSLayoutConstraint.activate([
            start.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 45),
            start.leadingAnchor.constraint(greaterThanOrEqualToSystemSpacingAfter: backgroundCard.leadingAnchor, multiplier: 1),
            start.trailingAnchor.constraint(equalTo: backgroundCard.trailingAnchor, constant: -8)

        ])
    }
    
    
    fileprivate func manageTimerImageConstraints() {
        NSLayoutConstraint.activate([
            manageTimerImage.topAnchor.constraint(equalTo: manageTimerView.topAnchor, constant: 5),
            manageTimerImage.leadingAnchor.constraint(greaterThanOrEqualToSystemSpacingAfter: backgroundCard.leadingAnchor, multiplier: 1),
            manageTimerImage.trailingAnchor.constraint(equalTo: manageTimerView.trailingAnchor, constant: -5),
            
            manageTimerView.topAnchor.constraint(equalTo: backgroundCard.topAnchor, constant: 10),
            manageTimerView.leadingAnchor.constraint(equalTo: backgroundCard.leadingAnchor, constant: 315),
            manageTimerView.trailingAnchor.constraint(equalTo: backgroundCard.trailingAnchor, constant: -5),
            manageTimerView.heightAnchor.constraint(equalToConstant: 50)
        
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
        let formattedTime = result.timeOfDay.formatted(date: .omitted, time: .shortened)
        
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
            // declare a empty string first before looping and += to text to avoid null error
            repeatDayLabel.text = ""
            for i in RepeatDay {
                repeatDayLabel.text! += " \(i)"
            }
        } else {
            repeatDayLabel.text = result.date.formatted(date: .abbreviated, time: .omitted)
        }
        repeatDayLabel.text! += "  (\(formattedTime))"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
