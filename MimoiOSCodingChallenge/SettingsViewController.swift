//
//  Created by Mimohello GmbH on 16.02.17.
//  Copyright (c) 2017 Mimohello GmbH. All rights reserved.
//
	
extension SettingsViewController : SettingsTableViewCellDelegate {
    

	
	func switchChangedValue(switcher: UISwitch) {
        self.switchColor = switcher.isOn
        UserDefaults.standard.set(switcher.isOn, forKey: "switchColor")
		self.setupTableView()
	}
}
