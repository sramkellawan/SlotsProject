//
//  ContentView.swift
//  SlotsProject
//
//  Created by user224010 on 8/31/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var symbols = ["apple","star","cherry"]
    @State private var numbers = Array(repeating: 0, count: 9	)
    @State private var backgrounds = Array(repeating:Color.white, count: 9)
    @State private var credits = 1000
    private var betAmount = 5
    
    
    var body: some View {
        
        
        // background
        ZStack {
            Rectangle()
                .foregroundColor(.yellow)
                .edgesIgnoringSafeArea(.all)
            
            Rectangle()
                .foregroundColor(.blue)
                .rotationEffect(Angle(degrees: 45))
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                Spacer()
                //TITLE
                HStack{
                  /// added comments
                Text("Sean's Lucky Slots")
                        .bold()
                        .foregroundColor(.black)
                        .padding(.all, 15)
                        .padding([.leading, .trailing],30)
                        .background(Color.yellow)
                        .cornerRadius(15)
                }
                Spacer()
                //CREDITS Counter
                Text("Credits: " + String(credits))
                    .foregroundColor(.black)
                    .padding(.all, 10)
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(20)
                Spacer()
                
                // Cards
                VStack{
                    HStack{
                        Spacer()
                        CardView(symbol: $symbols[numbers[0]], background: $backgrounds[0])
                        CardView(symbol: $symbols[numbers[1]], background: $backgrounds[1])
                        CardView(symbol: $symbols[numbers[2]], background: $backgrounds[2])
                        Spacer()
                    }
                    HStack{
                        Spacer()
                        CardView(symbol: $symbols[numbers[3]], background: $backgrounds[3])
                        CardView(symbol: $symbols[numbers[4]], background: $backgrounds[4])
                        CardView(symbol: $symbols[numbers[5]], background: $backgrounds[5])
                        Spacer()
                    }
                    HStack{
                        Spacer()
                        CardView(symbol: $symbols[numbers[6]], background: $backgrounds[6])
                        CardView(symbol: $symbols[numbers[7]], background: $backgrounds[7])
                        CardView(symbol: $symbols[numbers[8	]], background: $backgrounds[8])
                        Spacer()
                    }
                }

                Spacer()
                //Button
                
                HStack(spacing: 20){
                    VStack{
                        Button(action:{
                            
                            // process a single spin
                            self.processResults()
                            
                        }){
                            Text("Spin")
                                .bold()
                                .foregroundColor(.white)
                                .padding(.all, 10)
                                .padding([.leading, .trailing],30)
                                .background(Color.pink)
                                .cornerRadius(20)
                        }
                        Text("\(betAmount) Credits").padding(.top, 10).font(.footnote)
                    }
                    
                    VStack{
                        Button(action:{
                            
                            // process a single spin
                            self.processResults(true)
                            
                        }){
                            Text("Max Spin")
                                .bold()
                                .foregroundColor(.white)
                                .padding(.all, 10)
                                .padding([.leading, .trailing],30)
                                .background(Color.pink)
                                .cornerRadius(20)
                        }
                        Text("\(betAmount * 5) Credits").padding(.top, 10).font(.footnote)
                    }
                    
                    
                }
                	

                
                Spacer()
                
            }

        }
        
    }
    	
    func processResults(_ isMax:Bool = false){
        // Update background color to white

        // set all backgrounds to white
        self.backgrounds = self.backgrounds.map({
            _ in Color.white
        })
        
        if isMax {
            //randomize all nine cards
            self.numbers = self.numbers.map({_ in
                Int.random(in:0...self.symbols.count - 1)
                	
            })
        }else{
            //randomize middle row only
            // change the images
            self.numbers[3] = Int.random(in:0...self.symbols.count - 1)
            self.numbers[4] = Int.random(in:0...self.symbols.count - 1)
            self.numbers[5] = Int.random(in:0...self.symbols.count - 1)
        }
        

        // check winnings
        processWin(isMax)
        

    }
    
    func processWin(_ isMax:Bool = false){
        var matches = 0
        var row1 = false
        var row2 = false
        var row3 = false
//        var jackpot = false
        
        if !isMax{
            //processing for single spin
            if isMatch(3,4,5){matches += 1}

        }else{
            //process for max spin
            //check top row
            if isMatch(0,1,2){matches += 1
                row1 = true
            }
            
            //check middle row
            if isMatch(3,4,5){matches += 1
                row2 = true
            }

            // check bottom row
            if isMatch(6,7,8){matches += 1
                row3 = true
            }

            //Check Diagonal 1
            if isMatch(0,4,8){matches += 1}

            // check diagonal 2
            if isMatch(2,4,6){matches += 1}
            
            // check column 1
            if isMatch(0,3,6){matches += 1}
            // check column 2
            if isMatch(1,4,7){matches += 1}
            // check column 3
            if isMatch(2,5,8){matches += 1}
            
            // Check for Jackpot all square have the same symbol
            if isJackPot(0,1,2,3,4,5,6,7,8){ matches += 1000}

        }
        	
        if matches > 0{
            // bonus for 3  all rows match
            if row1 && row2 && row3 {
                self.credits += matches * betAmount * 5
            }else{
            // at least 1 win
            self.credits += matches * betAmount * 3
            }
        }else if !isMax{
            // 0 win single spin
            self.credits -= betAmount
        }else{
            // 0 wins max spin
            self.credits -= betAmount * 5
        }
        func isMatch(_ 	index1:Int, _ index2:Int, _ index3:Int) ->
        Bool{
            if self.numbers[index1] == self.numbers[index2] && self.numbers[index2] == self.numbers[index3]{
                self.backgrounds[index1] = Color.red
                self.backgrounds[index2] = Color.red
                self.backgrounds[index3] = Color.red
                return true
            }
            
            return false
        }
        
        func isJackPot(_     index1:Int, _ index2:Int, _ index3:Int, _ index4:Int, _ index5:Int, _ index6:Int, _ index7:Int, _ index8:Int, _ index9: Int) ->
        Bool{
            if self.numbers[index1] == self.numbers[index2] && self.numbers[index2] == self.numbers[index3]
                && self.numbers[index3] == self.numbers[index4]
                && self.numbers[index4] == self.numbers[index5]
                && self.numbers[index5] == self.numbers[index6]
                && self.numbers[index7] == self.numbers[index8]
                && self.numbers[index8] == self.numbers[index9]
            
            {
                self.backgrounds[index1] = Color.red
                self.backgrounds[index2] = Color.red
                self.backgrounds[index3] = Color.red
                self.backgrounds[index4] = Color.red
                self.backgrounds[index5] = Color.red
                self.backgrounds[index6] = Color.red
                self.backgrounds[index7] = Color.red
                self.backgrounds[index8] = Color.red
                self.backgrounds[index9] = Color.red
                return true
            }
            
            return false
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
