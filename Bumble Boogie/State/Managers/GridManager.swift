//
//  GridManager.swift
//  BumbleBoogie
//
//  Created by Peter Abbott on 13/02/2025.
//

import Foundation
import SpriteKit

//MARK: - Spawnpoints

class SpawnPoint: Hashable {
    let position: CGPoint
    var isOccupied: Bool = false
    weak var occupyingNode: SKNode?
    var neighbourPoints: [SpawnPoint]
    let debugNode: SKShapeNode?
    
    init(position: CGPoint, debugMode: Bool = false) {
        self.position = position
        self.neighbourPoints = []
        
        let node = SKShapeNode(circleOfRadius: 1)
        node.strokeColor = .gray
        node.fillColor = .gray
        node.position = position
        node.isHidden = !debugMode
        self.debugNode = node
        
    }
    
    func setOccupied(_ occupied: Bool, by node: SKNode? = nil) {
        isOccupied = occupied
        occupyingNode = node
        debugNode?.fillColor = occupied ? .red : .green
    }
    
    // MARK: - Hashable Conformance
    static func == (lhs: SpawnPoint, rhs: SpawnPoint) -> Bool {
        // Two spawn points are equal if they have the same position
        return lhs.position == rhs.position
    }
    
    func hash(into hasher: inout Hasher) {
        // Hash based on the position since it's unique for each spawn point
        hasher.combine(position.x)
        hasher.combine(position.y)
    }
}

//MARK: - Grid manager
class GridManager {
    // MARK: - Properties
    private let scene: SKScene
    private let gridSize: (columns: Int, rows: Int)
    private let cellSize: CGFloat
    private var debugMode: Bool  // Changed to var to allow toggling
    
    private var spawnPoints: [[SpawnPoint]] = []
    private var availablePoints: Set<SpawnPoint> = []
    
    // MARK: - Debug Visualization
    func toggleDebugMode() {
        debugMode = !debugMode
        updateDebugVisualization()
    }
    
    private func updateDebugVisualization() {
        for row in spawnPoints {
            for point in row {
                if debugMode {
                    // Show and update debug nodes
                    point.debugNode?.isHidden = false
                    point.debugNode?.fillColor = point.isOccupied ? .red : .gray
                } else {
                    // Hide debug nodes
                    point.debugNode?.isHidden = true
                }
            }
        }
    }
    
    
    // MARK: - Initialization
    init(scene: SKScene, columns: Int = 8, rows: Int = 12, cellSize: CGFloat = 50, debugMode: Bool = false) {
        self.scene = scene
        self.gridSize = (columns, rows)
        self.cellSize = cellSize
        self.debugMode = debugMode
        
        setupGrid()
        addDebugVisualization()  // Always add visualization, but it will be hidden if debug mode is false
    }
    
    
    //MARK: - Grid setup
    private func setupGrid() {
        // Calculate the starting position to center the grid
        let startX = (scene.size.width - CGFloat(gridSize.columns) * cellSize) / 2
        let startY = (scene.size.height - CGFloat(gridSize.rows) * cellSize) / 2
        
        // Create spawn points
        for row in 0..<gridSize.rows {
            var rowPoints: [SpawnPoint] = []  // Fixed: rowSpawnpoints -> rowPoints
            for col in 0..<gridSize.columns {
                let x = startX + CGFloat(col) * cellSize + cellSize/2
                let y = startY + CGFloat(row) * cellSize + cellSize/2
                let point = SpawnPoint(position: CGPoint(x: x, y: y), debugMode: debugMode)
                rowPoints.append(point)        // Fixed: matches array name above
                availablePoints.insert(point)
            }
            spawnPoints.append(rowPoints)      // Fixed: spawnpoints -> spawnPoints
        }
        
        setupNeighbors()                      // Fixed: setupNeighbours -> setupNeighbors
    }
    
    private func setupNeighbors() {
        for row in 0..<gridSize.rows {
            for col in 0..<gridSize.columns {
                let point = spawnPoints[row][col]
                //check adjacent cells
                for rowOffset in -1...1 {
                    for colOffset in -1...1 {
                        if rowOffset == 0 && colOffset == 0 { continue }
                        
                        let newRow = row + rowOffset
                        let newCol = col + colOffset
                        
                        if newRow >= 0 && newRow < gridSize.rows &&
                            newCol >= 0 && newCol < gridSize.columns {
                            point.neighbourPoints.append(spawnPoints[newRow][newCol])
                        }
                    }
                }
            }
        }
    }
    
    private func addDebugVisualization() {
        for row in spawnPoints {
            for point in row {
                if let debugNode = point.debugNode {
                    scene.addChild(debugNode)
                }
            }
        }
    }
    
    //MARK: - Spawn point management
    
    func getRandomAvailableSpawnPoint() -> SpawnPoint? {
        let availableNonNeigbouringPoints = availablePoints.filter { point in
            !point.isOccupied && !point.neighbourPoints.contains(where: { $0.isOccupied })
        }
        return availableNonNeigbouringPoints.randomElement()
    }
    
    func occupySpawnPoint(_ point: SpawnPoint, with node: SKNode) {
        point.setOccupied(true, by: node)
        availablePoints.remove(point)
    }
    
    func releasePoint(_ point: SpawnPoint) {
        point.setOccupied(false)
        availablePoints.insert(point)
    }
    
    //MARK: - Grid information
    func isPointAvailable(_ point: SpawnPoint) -> Bool {
        return !point.isOccupied && !point.neighbourPoints.contains(where: { $0.isOccupied })
    }
    
    func getNumberOfAvailablePoints() -> Int {
        return availablePoints.count
    }
    
}
