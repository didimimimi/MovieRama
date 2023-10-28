//
//  DateUtilities.swift
//  MovieRama
//
//  Created by  Dimitris Tasios Personal on 28/10/23.
//

import Foundation

class DateUtilities {
    func formatDate(date dateString: String?) -> String? {
        guard let dateString else {
            return nil
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "dd MMMM yyyy"
            dateFormatter.locale = Locale(identifier: "en_US")
            let formattedDate = dateFormatter.string(from: date)
            
            return formattedDate
        } else {
            return nil
        }
    }
}
