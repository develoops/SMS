//
//  ViewController.swift
//  SMS
//
//  Created by Arturo Sanhueza on 28-06-17.
//  Copyright © 2017 Arturo Sanhueza. All rights reserved.
//

import UIKit
import Parse

class ProgramaVC: UIViewController,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var tabla: UITableView!
    @IBOutlet weak var botonAvanzar: UIButton!
    @IBOutlet weak var botonRetroceder: UIButton!
    @IBOutlet weak var diaControl: UILabel!
    var tamanoCelda = CGFloat()
    var dateFormatter = DateFormatter()
    var eventosFiltrados = [PFObject]()
    var indicador = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        
        tabla.delegate = self
        tabla.dataSource = self
        botonAvanzar.addTarget(self, action: #selector(avanzar), for: .touchUpInside)
        botonRetroceder.addTarget(self, action: #selector(retroceder), for: .touchUpInside)
        botonRetroceder.isHidden = true
        diaControl.text = diasPrograma()[indicador]
        filtrarArray(indicador: indicador)
        
        let colorFondoHeaderDetalle = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.tabla.frame.origin.y))
        colorFondoHeaderDetalle.backgroundColor = UIColor(red: 194/255.0, green: 206/255.0, blue: 210/255.0, alpha: 1.0)
        self.view.addSubview(colorFondoHeaderDetalle)
        view.sendSubview(toBack: colorFondoHeaderDetalle)
    }
    
      override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Programa"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabla.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return eventosFiltrados.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
            return tamanoCelda
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        

        let evento = eventosFiltrados[indexPath.row]
        let fechaInicio = dateFormatter.formatoHoraMinutoString(fecha: evento["inicio"] as! NSDate!)
        let fechaFin = dateFormatter.formatoHoraMinutoString(fecha: evento["fin"] as! NSDate!)

        cell.labelTitulo?.textColor = UIColor(red: 8/255, green: 8/255, blue: 8/255, alpha: 1)
        cell.labelTitulo?.frame = CGRect(x: 38.0, y: 20.0, width: view.frame.size.width - 100.0, height:0.0)
        let maximumLabelSizeTitulo = CGSize(width: (self.view.frame.size.width - 100.0), height: 40000.0)
        cell.labelTitulo.sizeThatFits(maximumLabelSizeTitulo)
        cell.labelTitulo.font = UIFont.systemFont(ofSize: 16.0)
        cell.labelTitulo.text = evento["nombre"] as? String
        cell.labelTitulo?.textAlignment = .left
        cell.labelTitulo.numberOfLines = 0
        cell.labelTitulo?.sizeToFit()

        let maximumLabelSizeHora = CGSize(width: (self.view.frame.size.width - 114.0), height: 40000.0)

        cell.labelHora?.textColor = UIColor(red: 8/255, green: 8/255, blue: 8/255, alpha: 0.5)
        cell.labelHora?.frame =  CGRect(x: 38.0, y: cell.labelTitulo.frame.size.height + 35.0, width: 0.0, height: 0.0)
        cell.labelHora.font = UIFont.systemFont(ofSize: 14.0)
        cell.labelHora.sizeThatFits(maximumLabelSizeHora)
        cell.labelHora.text = fechaInicio + " - " + fechaFin
        cell.labelHora?.textAlignment = .left
        cell.labelHora.numberOfLines = 0
        cell.labelHora?.sizeToFit()

       let maximumLabelSizeLugar = CGSize(width: 10.0, height: 40000.0)
        cell.labelLugar?.textColor = UIColor(red: 8/255, green: 8/255, blue: 8/255, alpha: 0.5)
        cell.labelLugar?.frame = CGRect(x: 65.0 + cell.labelHora.frame.width, y: cell.labelTitulo.frame.size.height + 35.0, width: self.view.frame.size.width - (100.0 + cell.labelHora.frame.width), height: 40.0)
        cell.labelLugar.font = UIFont.systemFont(ofSize: 14.0)
        cell.labelLugar.sizeThatFits(maximumLabelSizeLugar)
        cell.labelLugar.text = evento["lugar"] as? String
        cell.labelLugar?.textAlignment = .left
        cell.labelLugar.numberOfLines = 0
        cell.labelLugar?.sizeToFit()
        
        var personasTamano = Int()
        
        if((evento["personas"] as! [PFObject]).count != 0){
            
            
            var personasString = String()
            let personas = evento["personas"] as! NSArray
            
            for object in (personas){
                
                let persona = object as! PFObject
                
                personasString.append((persona["tratamiento"] as? String)! + " " + (persona["nombre"] as? String)! + " " + (persona["apellido"] as! String) + "\n")
            personasTamano = personasTamano + (28 / ((evento["personas"] as! [PFObject]).count))
        }
            
            let maximumLabelSizePonente = CGSize(width: (self.view.frame.size.width - 152.0), height: 40000.0)
            cell.labelSpeaker1?.textColor = UIColor(red: 8/255, green: 8/255, blue: 8/255, alpha: 0.5)
            cell.labelSpeaker1?.frame = CGRect(x: 38.0, y: cell.labelTitulo.frame.size.height + 60.0, width: 0.0, height: 0.0)
            cell.labelSpeaker1.sizeThatFits(maximumLabelSizePonente)
            cell.labelSpeaker1.font = UIFont.systemFont(ofSize: 14.0)
            cell.labelSpeaker1.text = personasString
            cell.labelSpeaker1.numberOfLines = 0
            cell.labelSpeaker1?.textAlignment = .left
            cell.labelSpeaker1?.sizeToFit()
        
        }
        else{
            cell.labelSpeaker1.text = ""
        }
    
        tamanoCelda = cell.labelTitulo.frame.height + cell.labelLugar.frame.height + cell.labelHora.frame.height + cell.labelSpeaker1.frame.height + CGFloat(personasTamano)
       
        var colorImage = UIColor()
        if(evento["tipo"] as! String == "Conferencia")
        {
            colorImage = UIColor(red: 252/255.0, green: 171/255.0, blue: 83/255.0, alpha: 1.0)
        }
            
        else if (evento["tipo"] as! String == "Social") {
            
            colorImage = UIColor(red: 80/255.0, green: 210/255.0, blue: 194/255.0, alpha: 1.0)

        }
        else{
            colorImage = UIColor(red: 140/255.0, green: 136/255.0, blue: 255/255.0, alpha: 1.0)

        }
        
        cell.imagenMargen.image = getImageWithColor(color: colorImage, size: CGSize(width: 10.0, height:tamanoCelda))

        cell.botonFavorito.tag = indexPath.row
        cell.botonFavorito.addTarget(self, action: #selector(cambiarFavorito), for: .touchUpInside)
        
        if evento["favorito"] as? Bool == true {
            cell.botonFavorito.setImage(UIImage(named: "btn_Favorito_marcado.png"), for: .normal)
        }
        else{
            cell.botonFavorito.setImage(UIImage(named: "Btn_favoritos_SinMarcar.png"), for: .normal)
        }
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let evento = eventosFiltrados[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "detalleProgramaVC") as! DetalleProgramaVC
        let fechaInicio = dateFormatter.formatoHoraMinutoString(fecha: evento["inicio"] as! NSDate)
        let fechaFin = dateFormatter.formatoHoraMinutoString(fecha: evento["fin"] as! NSDate)

        vc.dia = dateFormatter.formatoDiaMesString(fecha: evento["inicio"] as! NSDate)
        vc.hora = fechaInicio + " - " + fechaFin
        vc.evento = evento
        
        if(evento["tipo"] as! String == "Conferencia")
        {
            vc.colorFondo = UIColor(red: 252/255.0, green: 171/255.0, blue: 83/255.0, alpha: 1.0)
        }
            
        else if (evento["tipo"] as! String == "Social") {
            
            vc.colorFondo = UIColor(red: 80/255.0, green: 210/255.0, blue: 194/255.0, alpha: 1.0)
            
        }
        else{
            vc.colorFondo = UIColor(red: 140/255.0, green: 136/255.0, blue: 255/255.0, alpha: 1.0)
            
        }

        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
    
    func eventos() ->AnyObject{
        
        let eventosQuery =  PFQuery(className: "Evento")
        eventosQuery.fromLocalDatastore()
        eventosQuery.includeKey("personas")
        
        return fetchAsync(query: eventosQuery).continue({ (task:BFTask<AnyObject>) -> Any? in
            return task.result as! [PFObject]
        })
    }

    func fetchAsync(query: PFQuery<PFObject>) -> BFTask<AnyObject> {
        let task = BFTaskCompletionSource<AnyObject>()

        do {
             task.setResult(try query.findObjects() as AnyObject )
            
        } catch {
            task.setError("Fallo: \(error)" as! Error)
        }
        
        return task.task
    }

    
    func diasPrograma() ->[String]{
        let results = eventos() 
        let eventosP = results.value(forKeyPath: "result") as! [PFObject]

        var diasPrograma = [String]()
        for index in 0...(eventosP.count - 1) {
            let fecha = eventosP[index]["inicio"]
            let fechaString = dateFormatter.formatoDiaMesCortoString(fecha: fecha! as! NSDate)
            diasPrograma.append(fechaString)
        }
        let diasProgramaFiltrados = uniqueElementsFrom(array:diasPrograma)
        
        return diasProgramaFiltrados
    }
    
    func diasProgramaDate() ->[String]{
        
        var diasPrograma = [String]()
        let results = eventos()
        let eventosP = results.value(forKeyPath: "result") as! [PFObject]

        for index in 0...(eventosP.count - 1) {

            let fecha = eventosP[index]["inicio"]
            let fechaString = dateFormatter.formatoAnoMesDiaString(fecha:fecha! as! NSDate)
            diasPrograma.append(fechaString)
        }
        
        let diasProgramaFiltrados = uniqueElementsFrom(array:diasPrograma)
        return diasProgramaFiltrados
    }
    
    func avanzar(sender: UIButton!){
        
        if(indicador < diasPrograma().count - 1){
            indicador = indicador + 1
            botonRetroceder.isHidden = false
        }
        
                    
        if(indicador == diasPrograma().count-1){
            botonAvanzar.isHidden = true
        }
        else {
            botonAvanzar.isHidden = false

        }
        diaControl.text = diasPrograma()[indicador]
        filtrarArray(indicador: indicador)
    }
    
    func retroceder(sender: UIButton!){
        
        if(indicador==1){
            botonRetroceder.isHidden = true
        }
        else {
            botonRetroceder.isHidden = false
        }
        if(indicador > 0){
            indicador = indicador - 1
        }
        
        if(indicador != diasPrograma().count-1){
            botonAvanzar.isHidden = false
        }
        diaControl.text = diasPrograma()[indicador]
        filtrarArray(indicador: indicador)
    }
    
    func cambiarFavorito(sender: UIButton!){
        let evento = eventosFiltrados[sender.tag]
        if (evento["favorito"] as? Bool == true) {
            evento.setValue(false, forKey: "favorito")
            sender.setImage(UIImage(named: "Btn_favoritos_SinMarcar.png"), for: .normal)
            
        }
        else{
            evento.setValue(true, forKey: "favorito")
           sender.setImage(UIImage(named: "btn_Favorito_marcado.png"), for: .normal)
        }
        evento.saveInBackground().continue({ (task:BFTask<NSNumber>) -> Any? in
        return task
        })
            
    
    }
    
    func filtrarArray(indicador:Int) {
        let results = eventos()
        let eventosP = results.value(forKeyPath: "result") as! [PFObject]

        let date1 = dateFormatter.formatoAnoMesDiaDate(string:diasProgramaDate()[indicador])
        
        let filteredArray = eventosP.filter() {
            
            return ($0["inicio"] as AnyObject).compare((date1.addingTimeInterval(60*60*24))) == ComparisonResult.orderedAscending && ($0["inicio"] as AnyObject).compare(date1) == ComparisonResult.orderedDescending
        }
        
        eventosFiltrados = filteredArray
        self.tabla.reloadData()
    }

    func uniqueElementsFrom(array: [String]) -> [String] {
        var set = Set<String>()
        let result = array.filter {
            guard !set.contains($0) else {
                return false
            }
            set.insert($0)
            return true
        }
        return result
    }
    
    func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 2.0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
  }

