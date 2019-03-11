//
//  FetchedResultsController.swift
//  SP_Test
//
//  Created by Hoof on 3/8/19.
//  Copyright © 2019 Retinal Media. All rights reserved.
//

import UIKit
import CoreData


protocol FetchedResultsControllerProtocol {
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>? { get set }
    var blockOperations: [BlockOperation]? { get set }
}

