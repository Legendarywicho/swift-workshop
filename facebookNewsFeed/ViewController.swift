//
//  ViewController.swift
//  facebookNewsFeed
//
//  Created by Luis Santiago  on 11/26/17.
//  Copyright © 2017 Luis Santiago . All rights reserved.
//

import UIKit

class Post {
    var name: String?
    var statusText : String?
    var profileImageViewName : UIImage?
    var imagePost : UIImage?
}

class ViewController: UICollectionViewController  , UICollectionViewDelegateFlowLayout{

    let customCellId = "cellId";
    var posts  =  [Post]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let postMark = Post();
        postMark.name = "Mark Zuckenberg";
        postMark.statusText = "Meanwhile , Beast turned into the darkside :)";
        postMark.profileImageViewName = #imageLiteral(resourceName: "mark");
        postMark.imagePost = #imageLiteral(resourceName: "dog");
        
        
        let postSteve = Post();
        postSteve.name = "Steve jobs";
        postSteve.statusText = "Your time is limited, so don't waste it living someone else's life. Don't be trapped by dogma - which is living with the results of other people's thinking.\nDon't let the noise of others' opinions drown out your own inner voice.\nAnd most important, have the courage to follow your heart and intuition";
        postSteve.profileImageViewName = #imageLiteral(resourceName: "steve");
        postSteve.imagePost = #imageLiteral(resourceName: "steve_post_image");
        
        posts.append(postMark);
        posts.append(postSteve);
        
        navigationItem.title = "News Feed";
        
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: customCellId);
        
        collectionView?.alwaysBounceVertical = true;
        
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count;
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: customCellId, for: indexPath) as! FeedCell;
        
        cell.post = posts[indexPath.item];
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let statusText = posts[indexPath.item].statusText {
            let rect = NSString(string: statusText).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14)], context : nil);
            
            let maxHeight : CGFloat = 370;
            
            return CGSize(width: view.frame.width, height: rect.height+maxHeight);
        }
        return CGSize(width: view.frame.width , height: 500);
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator);
        collectionView?.collectionViewLayout.invalidateLayout();
    }
    
}


class FeedCell : UICollectionViewCell{
    
     var post : Post? {
        didSet{
            if let name = post?.name {
                let attributedText = NSMutableAttributedString(
                    string: name,
                    attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14)]);
                
                attributedText.append(NSMutableAttributedString(string: "\nDecember 18  *  San Francisco  *  ", attributes: [
                    NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 12),
                    NSAttributedStringKey.foregroundColor: UIColor(red: 155/255, green: 161/255, blue: 171/255, alpha: 1)
                    ]));
                
                let paragraphStyle = NSMutableParagraphStyle();
                paragraphStyle.lineSpacing = 4
                attributedText.addAttributes([NSAttributedStringKey.paragraphStyle : paragraphStyle], range: NSMakeRange(0,attributedText.string.count));
                
                let attachment = NSTextAttachment()
                attachment.image = #imageLiteral(resourceName: "icons8-share-50")
                attachment.bounds = CGRect(x: 0, y: -2, width: 12, height: 12);
                attributedText.append(NSAttributedString(attachment: attachment));
                
                nameLabel.attributedText = attributedText;
            }
            
            if let statusText = post?.statusText{
                statusTextview.text = statusText;
            }
            
            if let imageProfile = post?.profileImageViewName{
                profileImageView.image = imageProfile;
            }
            if let postImageView = post?.imagePost{
                imageStatusView.image = postImageView;
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame);
        setUpViews();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel : UILabel = {
        let label = UILabel();
        label.numberOfLines = 2;
        
        return label;
    }();
    
    let profileImageView : UIImageView = {
        let image = UIImageView();
        image.contentMode = .scaleToFill;
        image.backgroundColor = .red;
        image.image = #imageLiteral(resourceName: "mark");
        return image;
    }();
    
    let statusTextview : UITextView = {
        let text = UITextView();
        text.font = UIFont.systemFont(ofSize: 14);
        text.isScrollEnabled = false;
        return text;
    }();
    
    let imageStatusView : UIImageView = {
        let image = UIImageView();
        image.image = #imageLiteral(resourceName: "dog");
        image.contentMode = .scaleToFill;
        image.layer.masksToBounds = true;
        return image;
    }()
    
    let likesCommentLabel : UILabel = {
        let label = UILabel();
        label.text = "480 Likes   10.7k Comments";
        label.font = .systemFont(ofSize: 12);
        label.textColor = UIColor.rgb(red: 155, green: 161, blue: 171);
        return label;
    }();
    
    let dividerLineView : UIView = {
        let line = UIView();
        line.backgroundColor = UIColor.rgb(red: 226, green: 228, blue: 232);
        return line;
    }()
    
    let likeButton  = FeedCell.generateButton(text: "Like", image: #imageLiteral(resourceName: "icons8-facebook-like-50"));
    let commentButton = FeedCell.generateButton(text: "Comment", image: #imageLiteral(resourceName: "icons8-send-comment-50"));
    let sharebutton = FeedCell.generateButton(text: "Share", image: #imageLiteral(resourceName: "icons8-share-50"));
    
    static func generateButton(text : String, image: UIImage)->UIButton{
        let button = UIButton();
        button.setTitle(text , for: .normal);
        button.setTitleColor(UIColor.rgb(red: 143, green: 150, blue: 163), for: .normal)
        button.setImage(image, for: .normal);
        button.titleLabel?.font = .boldSystemFont(ofSize: 14);
        button.titleEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 0);
        return button
    }
    
    func setUpViews(){
        backgroundColor = .white;
        addSubview(nameLabel);
        addSubview(profileImageView);
        addSubview(statusTextview);
        addSubview(imageStatusView);
        addSubview(likesCommentLabel);
        addSubview(dividerLineView);
        addSubview(likeButton);
        addSubview(commentButton);
        addSubview(sharebutton);
        
        addContraintsWithFormats(format:"H:|-8-[v0(44)]-8-[v1]|" , views: profileImageView, nameLabel)
        
        addContraintsWithFormats(format: "H:|-4-[v0]-4-|", views: statusTextview);
        
        addContraintsWithFormats(format: "H:|-12-[v0]|", views: likesCommentLabel);
        
        addContraintsWithFormats(format: "H:|[v0]|", views: imageStatusView);
        
        addContraintsWithFormats(format: "H:|-12-[v0]-12-|", views: dividerLineView);
        
        addContraintsWithFormats(format:"V:|-12-[v0]", views: nameLabel);
        
        //Button constraints
        addContraintsWithFormats(format: "H:|[v0(v2)][v1(v2)][v2]|", views: likeButton , commentButton , sharebutton);
        
        addContraintsWithFormats(format:"V:|-8-[v0(44)]-4-[v1]-4-[v2(200)]-8-[v3(24)]-8-[v4(0.4)][v5(44)]|", views: profileImageView, statusTextview, imageStatusView, likesCommentLabel , dividerLineView, likeButton);
        
        addContraintsWithFormats(format:"V:[v0(44)]|", views: commentButton);
        addContraintsWithFormats(format:"V:[v0(44)]|", views: sharebutton);
    }
}

extension UIColor {
    static func rgb(red : CGFloat , green : CGFloat, blue : CGFloat)->UIColor{
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1);
    }
}


extension UIView {
    func addContraintsWithFormats(format : String , views : UIView...){
        var viewsDictionary = [String : UIView]();
        for(index , view) in views.enumerated(){
            let key = "v\(index)";
            viewsDictionary[key] = view;
            view.translatesAutoresizingMaskIntoConstraints = false;
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

