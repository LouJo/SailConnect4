/* Copyright 2015 (C) Louis-Joseph Fournier 
 * louisjoseph.fournier@gmail.com
 *
 * This file is part of SailConnect4.
 *
 * SailConnect4 is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * SailConnect4 is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 */

import QtQuick 2.0
import QtQuick.Controls 1.4

import "."
import "../config"
import "configure"

StackView {
	id: stack
	initialItem: mainPage

	width: 400
	height: 640

	property var config: Config // for UI.cpp

	property QtObject game
	property QtObject menu

	Component {
		id: mainPage

		MainPage {
			onLaunchConfigure: stack.launchConfigure()

			Component.onCompleted: {
				stack.game = game
				stack.menu = menu
			}
		}
	}

	Component {
		id: configurePage

		Configure {
			onExit: stack.pop()
		}
	}

	function launchConfigure() {
		console.log("configure")
		stack.push({item: configurePage})
	}
}
