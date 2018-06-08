//
//  SSTableView.swift
//  Schedule School
//
//  Created by Máté on 2018. 02. 23..
//  Copyright © 2018. theMatys. All rights reserved.
//

import UIKit

class SSTableView: UITableView
{
    override func rectForRow(at indexPath: IndexPath) -> CGRect
    {
        let superResult: CGRect = super.rectForRow(at: indexPath)
        SSLogDebug(superResult)
        return superResult
    }
}
