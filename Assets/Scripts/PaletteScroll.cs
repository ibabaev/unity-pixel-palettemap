﻿/*****************************************************************************
 *  Copyright (C) 2014 Red Blue Games, LLC
 *  
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 ****************************************************************************/

using UnityEngine;
using System.Collections;

namespace RedBlueTools
{
	/// <summary>
	/// PaletteScroll scrolls a Material's PaletteY offset at a specified rate during Update.
	/// </summary>
	public class PaletteScroll : MonoBehaviour
	{

		string paletteVariable = "_PaletteY";
		public float scrollRate;

		void Update ()
		{
			float deltaY = scrollRate * Time.deltaTime;
			float currentPaletteY = renderer.material.GetFloat (paletteVariable);
			float newPaletteY = (currentPaletteY + deltaY) % 1.0f;

			// Set the paletteY for the given material.
			renderer.material.SetFloat (paletteVariable, newPaletteY);

			// This would change the palette for all objects using this material. Careful with this,
			// since changes will persist across Play mode.
			//renderer.sharedMaterial.SetFloat(paletteVariable, newPaletteY);
		}
	}

}