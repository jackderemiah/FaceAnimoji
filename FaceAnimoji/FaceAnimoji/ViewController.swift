//
//  ViewController.swift
//  FaceAnimoji
//
//  Created by ashutosh.dingankar on 9/30/19.
//  Copyright © 2019 ashutosh.dingankar. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var contentNode: SCNNode? = nil
    //var contentNode: SCNNode? = nil
    
    var morphs: [SCNGeometry] = []
    let morpher = SCNMorpher()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set ViewController as ARSCNView's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
     let scene = SCNScene(named: "art.scnassets/facial-setup-final.scn")!
     
        // Access scene's rootNode
        contentNode = scene.rootNode
        contentNode?.opacity = 0.89
        
       
        print("content node orientation : \(contentNode?.orientation)")
        print("content node euler angles : \(contentNode?.eulerAngles)")
        
        
        print("content node = \(contentNode)")
        print("content node child  = \(contentNode?.childNodes)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // "Reset" to run the AR session for the first time.
        resetTracking()
    }
    
    func resetTracking() {
        guard ARFaceTrackingConfiguration.isSupported else { return }
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
    
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        print("session was interrupted! ⏸")
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        print("resuming session! ▶️")
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard anchor is ARFaceAnchor else { return nil }
        return contentNode
    }
    
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        guard let faceAnchor = anchor as? ARFaceAnchor
            else { return }
        
        DispatchQueue.main.async {
            let blendShapes = faceAnchor.blendShapes
            
            // Looping through blendshapes.
            // setting the content node with the same values for each blendshape key! ( setWeight ).
            
            for (key, value) in blendShapes {
                
                if let faceValue = value as? Float{
                    
                    self.contentNode?.childNodes[0].morpher?.setWeight(CGFloat( faceValue ), forTargetNamed: key.rawValue)
                                  
                    
                }
            }
        }
        
    }
}
