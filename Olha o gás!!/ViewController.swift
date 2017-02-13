//
//  ViewController.swift
//  Olha o gás!!
//
//  Created by Vinicius Nadin on 26/01/17.
//  Copyright © 2017 Nadin. All rights reserved.
//

import UIKit
import AVFoundation
import GoogleMobileAds
import AudioToolbox

class ViewController: UIViewController, GADBannerViewDelegate, AVAudioPlayerDelegate {
    
    var audioPlayers = [AVAudioPlayer]()
    var urlGEsquerda : URL!
    var urlGDireita : URL!
    var urlGLados : URL!
    var urlGas : URL!
    var urlGasCompleto : URL!
    var adMobBannerView = GADBannerView()
    let ADMOB_BANNER_UNIT_ID = "ca-app-pub-5362862007344886/5545656253"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        var audioPath = Bundle.main.path(forResource: "gasEsquerda", ofType: "mp3")
        self.urlGEsquerda = URL(fileURLWithPath: audioPath!)
        
        audioPath = Bundle.main.path(forResource: "gasDireita", ofType: "mp3")
        self.urlGDireita = URL(fileURLWithPath: audioPath!)
        
        audioPath = Bundle.main.path(forResource: "gasLados", ofType: "mp3")
        self.urlGLados = URL(fileURLWithPath: audioPath!)
        
        audioPath = Bundle.main.path(forResource: "oGas", ofType: "mp3")
        self.urlGas = URL(fileURLWithPath: audioPath!)
        audioPath = Bundle.main.path(forResource: "gasCompleto", ofType: "mp3")
        self.urlGasCompleto = URL(fileURLWithPath: audioPath!)
        initAdMobBanner()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func gasEsquerda(_ sender: UIButton) {
        self.tocarSom(url: self.urlGEsquerda)
    }
    
    @IBAction func gasDireita(_ sender: UIButton) {
        self.tocarSom(url: self.urlGDireita)
    }
    
    @IBAction func gasLados(_ sender: UIButton) {
        self.tocarSom(url: self.urlGLados)
    }
    
    @IBAction func oGas(_ sender: UIButton) {
        self.tocarSom(url: self.urlGas)
    }
    @IBAction func gasCompleto(_ sender: UIButton) {
        self.tocarSom(url: self.urlGasCompleto)
    }
    @IBAction func parar(_ sender: UIButton) {
        for player in self.audioPlayers {
            player.stop()
        }
        self.audioPlayers.removeAll()
    }
    
    
    func tocarSom(url : URL){
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: url)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            audioPlayer.delegate = self
            self.audioPlayers.append(audioPlayer)
            audioPlayer.play()
        } catch{}
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        let index = self.audioPlayers.index(of: player)
        self.audioPlayers.remove(at: index!)
    }
    
    // MARK: -  ADMOB BANNER
    func initAdMobBanner() {
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            // iPhone
            adMobBannerView.adSize =  GADAdSizeFromCGSize(CGSize(width: 320, height: 50))
            adMobBannerView.frame = CGRect(x: 0, y: view.frame.size.height, width: 320, height: 50)
        } else  {
            // iPad
            adMobBannerView.adSize =  GADAdSizeFromCGSize(CGSize(width: 468, height: 60))
            adMobBannerView.frame = CGRect(x: 0, y: view.frame.size.height, width: 468, height: 60)
        }
        
        adMobBannerView.adUnitID = ADMOB_BANNER_UNIT_ID
        adMobBannerView.rootViewController = self
        adMobBannerView.delegate = self
        view.addSubview(adMobBannerView)
        
        let request = GADRequest()
        adMobBannerView.load(request)
    }
    
    
    // Hide the banner
    func hideBanner(_ banner: UIView) {
        UIView.beginAnimations("hideBanner", context: nil)
        banner.frame = CGRect(x: view.frame.size.width/2 - banner.frame.size.width/2, y: view.frame.size.height - banner.frame.size.height, width: banner.frame.size.width, height: banner.frame.size.height)
        UIView.commitAnimations()
        banner.isHidden = true
    }
    
    // Show the banner
    func showBanner(_ banner: UIView) {
        UIView.beginAnimations("showBanner", context: nil)
        banner.frame = CGRect(x: view.frame.size.width/2 - banner.frame.size.width/2, y: view.frame.size.height - banner.frame.size.height, width: banner.frame.size.width, height: banner.frame.size.height)
        UIView.commitAnimations()
        banner.isHidden = false
    }
    
    // AdMob banner available
    func adViewDidReceiveAd(_ view: GADBannerView) {
        showBanner(adMobBannerView)
    }
    
    // NO AdMob banner available
    func adView(_ view: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        hideBanner(adMobBannerView)
    }


}

