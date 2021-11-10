//
//  ViewController.swift
//  iOS_RandomPlaceARGame
//
//  Created by Ahmad Abdulrady
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var counterLabel: UILabel!
    
    let modelName = ""
    var foundObjects = 0 {
        didSet {
            counterLabel.text = "Your Score is \(foundObjects)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.debugOptions = .showFeaturePoints
        
        // Create a new scene
        let scene = SCNScene()
        addRandomPostionObject()
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.isLightEstimationEnabled = true

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    func randomPostion(upperBound: Float, lowerBound: Float) -> Float {
        return Float.random(in: upperBound ... lowerBound)
    }
    
    func addRandomPostionObject() {
        let sphere = SCNSphere(radius: 0.1)
        sphere.firstMaterial?.diffuse.contents = UIImage(named: "world.topo")
        let node = SCNNode(geometry: sphere)
        let xPos = randomPostion(upperBound: 2, lowerBound: -2)
        let yPos = randomPostion(upperBound: 2, lowerBound: -2)
        let zPos = randomPostion(upperBound: 2, lowerBound: -2)
        node.position = SCNVector3(xPos, yPos, zPos)
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            let hits = sceneView.hitTest(touchLocation)
            if let hit = hits.first {
                let node = hit.node
                if node.name == modelName {
                    node.removeFromParentNode()
                    foundObjects += 1
                    addRandomPostionObject()
                }
            }
        }
    }
}
