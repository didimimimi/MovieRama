/* 
Copyright (c) 2023 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
struct ApiReview : Codable {
	let author : String?
	let author_details : ApiAuthorDetails?
	let content : String?
	let created_at : String?
	let id : String?
	let updated_at : String?
	let url : String?

	enum CodingKeys: String, CodingKey {

		case author = "author"
		case author_details = "author_details"
		case content = "content"
		case created_at = "created_at"
		case id = "id"
		case updated_at = "updated_at"
		case url = "url"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		author = try values.decodeIfPresent(String.self, forKey: .author)
		author_details = try values.decodeIfPresent(ApiAuthorDetails.self, forKey: .author_details)
		content = try values.decodeIfPresent(String.self, forKey: .content)
		created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
		url = try values.decodeIfPresent(String.self, forKey: .url)
	}

}
