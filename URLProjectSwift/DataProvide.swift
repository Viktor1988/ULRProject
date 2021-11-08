//
//  DataProvide.swift
//  URLProjectSwift
//
//  Created by Виктор Попов on 15.06.2021.
//  Copyright © 2021 Виктор Попов. All rights reserved.
//

import UIKit

class DataProvide: NSObject {
    
    private var downloadTask : URLSessionDownloadTask!
    var fileLocation : ((URL)->())?
    var onProgress : ((Double)->())?
    
    private lazy var bgSession : URLSession = {
        let config = URLSessionConfiguration.background(withIdentifier: "ru.vpopov.URLProjectSwift")// передается budle identifire нашего приложения
        //        config.isDiscretionary = true //могут ли фоновые задачи быть предусмотрены системой для оптимальной производительности
        config.sessionSendsLaunchEvents = true // по завершению работы с данными приложение запустится в фоновом режиме ивызывет метод urlSessionDidFinishEvents
        //при этом в appDelegate должен быть метод, который перехватыет нашу сессию 
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
    
    func startDownload() {
        if let url = URL(string: "https://speed.hetzner.de/100MB.bin") {
            downloadTask = bgSession.downloadTask(with: url)//создаем экземпляр URLSession
            downloadTask.earliestBeginDate = Date().addingTimeInterval(3) //указываем интервал запуска, через 3 секунды, после начала
            downloadTask.countOfBytesClientExpectsToSend = 512//верхняя граница принимаемого размера файла, который отправится - ???
            downloadTask.countOfBytesClientExpectsToReceive = 100 * 1024 * 1024//наиболее вероятнуюю границу, которую ожидает получить пользователь
            downloadTask.resume()
        }
    }
    
    func stopDownload() {
        downloadTask.cancel()
    }
}

extension DataProvide: URLSessionDelegate {
    //вызывается после завершения всех фоновых задач с нащим идентификатором
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        DispatchQueue.main.async {
            guard
                let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                let completionHandler = appDelegate.bgSessionCompletionHandler // передаем идентификатор захваченной нашей сессии из свойства bgSessionCompletionHandler из класса appDalegate
                else { return  }
            appDelegate.bgSessionCompletionHandler = nil
            completionHandler()//вызываем исходный метод completionHandler, чтобы уведомить о том, что загрузка была завершена
        }
    }
}

extension DataProvide : URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Did finished download: \(location.absoluteString)")//вывод абсолютного пути временного файла после его загрузки
        DispatchQueue.main.async {
            self.fileLocation?(location)//сохраняем ссылку в постоянной переменной из временной
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        guard totalBytesExpectedToWrite != NSURLSessionTransferSizeUnknown else { return }
        let progress =  Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        print("Download progress: \(progress)")
        DispatchQueue.main.async {
            self.onProgress?(progress)
        }
    }
}
