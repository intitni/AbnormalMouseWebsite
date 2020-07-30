import Foundation
import Publish

//struct AppCastsGenerator {
//    private let data: Data
//    init(gitReleaseData: Data) {
//        data = gitReleaseData
//    }
//    
//    func generate() throws {
//        let outputFile = try context.createOutputFile(at: "appcasts.xml")
//        let content = ""
//        try outputFile.write(content)
//    }
//}
//
//extension Plugin {
//    static var generateAppcasts: Self {
//        Plugin(name: "Generate AppCasts file from github release") { _ in
//            let semaphore = DispatchSemaphore(value: 0)
//            var data: Data?
//            var response: URLResponse?
//            var error: Error?
//            
//            var request = URLRequest()
//
//            let task = URLSession.shared.dataTask(with: request) {
//                data = $0
//                response = $1
//                error = $2
//                semaphore.signal()
//            }
//
//            task.resume()
//            semaphore.wait()
//            
//            if let data = data {
//                let generator = AppCastsGenerator(gitReleaseData: data)
//                try generator.generate()
//            } else if let error = error {
//                throw error
//            } else {
//                struct E: Error {}
//                throw E()
//            }
//        }
//    }
//}
