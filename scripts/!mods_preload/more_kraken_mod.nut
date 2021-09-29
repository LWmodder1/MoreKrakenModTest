::mods_registerMod("mod_more_krakens", 1.0, "Spawning more Krakens");
::mods_queue("mod_more_krakens", null, function()
{
	::mods_hookNewObject("factions/actions/send_beast_roamers_action", function ( obj )
	{
		local beast = function ( _action, _nearTile = null )
		{
			local disallowedTerrain = [];
			local distanceToNextAlly = 10;
			
			// i add this so it won't be messy with a tons of i == || i == || i === ....
			local validTerrain = [
				this.Const.World.TerrainType.Swamp,
				this.Const.World.TerrainType.Ocean,
				this.Const.World.TerrainType.Shore,
				this.Const.World.TerrainType.Oasis,
				this.Const.World.TerrainType.Plains,
				this.Const.World.TerrainType.Mountains,
				this.Const.World.TerrainType.Forest,
				this.Const.World.TerrainType.LeaveForest,
				this.Const.World.TerrainType.AutumnForest
			];

			for( local i = 0; i < this.Const.World.TerrainType.COUNT; i = i )
			{
				if (validTerrain.find(i) != null)
				{
				}
				else
				{
					disallowedTerrain.push(i);
				}

				i = ++i;
			}

			local tile = _action.getTileToSpawnLocation(10, disallowedTerrain, 7, 100, 1000, 3, 0, _nearTile, 0.0, 0.9);

			if (tile == null)
			{
				return false;
			}

			if (_action.getDistanceToNextAlly(tile) <= distanceToNextAlly / (_nearTile == null ? 1 : 2))
			{
				return false;
			}

			local distanceToNextSettlement = _action.getDistanceToSettlements(tile);

			if (this.LegendsMod.Configs().LegendLocationScalingEnabled())
			{
				distanceToNextSettlement = distanceToNextSettlement * 2;
			}

			local party = _action.getFaction().spawnEntity(tile, "Kraken", false, this.Const.World.Spawn.Kraken, 1000);
			party.getSprite("banner").setBrush("banner_beasts_01");
			party.setDescription("A tentacled horror from another age.");
			party.setFootprintType(this.Const.World.FootprintsType.Kraken);
			party.setSlowerAtNight(true);
			party.setUsingGlobalVision(false);
			party.setLooting(false);

			// set the new base speed only 100% and visibility 100%
			party.setMovementSpeed(this.Math.floor(party.getBaseMovementSpeed() * 1.0));
			party.setVisibilityMult(this.Math.floor(party.getVisibilityMult() * 1.0));

			local roam = this.new("scripts/ai/world/orders/roam_order");
			roam.setNoTerrainAvailable();
			
			// set terrain type so spawned kraken don't roam outside of intended terrain
			roam.setTerrain(this.Const.World.TerrainType.Swamp, true);
			roam.setTerrain(this.Const.World.TerrainType.Ocean, true);
			roam.setTerrain(this.Const.World.TerrainType.Shore, true);
			roam.setTerrain(this.Const.World.TerrainType.Oasis, true);
			roam.setTerrain(this.Const.World.TerrainType.Plains, true);
			roam.setTerrain(this.Const.World.TerrainType.Mountains, true);
			roam.setTerrain(this.Const.World.TerrainType.Forest, true);
			roam.setTerrain(this.Const.World.TerrainType.LeaveForest, true);
			roam.setTerrain(this.Const.World.TerrainType.AutumnForest, true);
			party.getController().addOrder(roam);
			return true;
		};
		
		// I push this function 10 times so there is more chance for fucntion to be picked
		obj.m.Options.push(beast);
		obj.m.Options.push(beast);
		obj.m.Options.push(beast);
		obj.m.Options.push(beast);
		obj.m.Options.push(beast);
		obj.m.Options.push(beast);
		obj.m.Options.push(beast);
		obj.m.Options.push(beast);
		obj.m.Options.push(beast);
		obj.m.Options.push(beast);
	});
})
