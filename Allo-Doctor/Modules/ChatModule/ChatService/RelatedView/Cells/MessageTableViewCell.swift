//
//  MessageTableViewCell.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 06/01/2025.
//

import UIKit
import Kingfisher // left in case you still want to use it elsewhere

enum messageType {
    case sender
    case reciver
}

final class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var stackVw: UIStackView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var imagView: UIImageView!

    // Keep track of async task & expected url to avoid race conditions on reuse
    private var imageLoadTask: Task<Void, Never>?
    private var currentImageURL: URL?

    // Simple in-memory cache
    private static let imageCache = NSCache<NSURL, UIImage>()

    override func awakeFromNib() {
        super.awakeFromNib()
        // optional: prepare imageView appearance
        imagView.contentMode = .scaleAspectFill
        imagView.clipsToBounds = true
        imagView.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0))
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        // cancel ongoing image download and reset UI
        imageLoadTask?.cancel()
        imageLoadTask = nil
        currentImageURL = nil
        imagView.image = nil
        imagView.isHidden = true
        message.text = nil
        message.isHidden = false
    }
}

extension MessageTableViewCell {

    func setupCell(message: String?, attachment: String?, messageType: messageType) {
        // TEXT
        self.message.text = message
        self.message.numberOfLines = 0
        let hasText = (message?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false)
        self.message.isHidden = !hasText

        // Appearance (colors + alignment) based on message type and RTL
        let isReceiver = (messageType == .reciver)
        if isReceiver {
            // original logic kept (adjust if you want swapped behavior)
            self.message.textAlignment = LocalizationManager.shared.isRTL() ? .left : .right
            self.contentView.backgroundColor = .greishWhiteF2F2F2
            self.message.textColor = .black
        } else {
            self.message.textAlignment = LocalizationManager.shared.isRTL() ? .right : .left
            self.contentView.backgroundColor = .appColor
            self.message.textColor = .white
        }

        // IMAGE HANDLING (async/await)
        // Cancel any previous image loading task (important for cell reuse)
        imageLoadTask?.cancel()
        imageLoadTask = nil
        imagView.image = nil
        currentImageURL = nil

        // If no attachment provided -> hide image and return
        guard let att = attachment, att.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false,
              let url = URL(string: att) else {
            imagView.isHidden = true
            return
        }

        // Show imageView and remember expected url
        imagView.isHidden = false
        currentImageURL = url

        // If cached -> set immediately
        if let cached = Self.imageCache.object(forKey: url as NSURL) {
            imagView.image = cached
            return
        }

        // Start async download task
        imageLoadTask = Task { [weak self] in
            // quick cancellation check
            if Task.isCancelled { return }

            do {
                // download data (async)
                let (data, response) = try await URLSession.shared.data(from: url)

                // check http status (optional)
                if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
                    return
                }

                // create image
                guard let img = UIImage(data: data) else { return }

                // cache the image
                Self.imageCache.setObject(img, forKey: url as NSURL)

                // if cancelled in the meantime -> bail
                if Task.isCancelled { return }

                // apply image on main actor and ensure the cell still expects this url
                await MainActor.run {
                    guard let self = self else { return }
                    if self.currentImageURL == url {
                        self.imagView.image = img
                    }
                }
            } catch {
                // ignore cancellations; for other errors you can set a placeholder if desired
                if !Task.isCancelled {
                    await MainActor.run { [weak self] in
                        self?.imagView.image = nil
                    }
                }
            }
        }
    }
}
