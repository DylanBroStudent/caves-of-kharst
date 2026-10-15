using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CavesOfKharst.DataAccess
{
    internal class CharacterDAO : DAOClass
    {
        // datatable to hold characters
        public DataTable GetCharacters(int userAccountId)
        {
            try
            {
                _connection.Open();

                MySqlCommand command =
                    new MySqlCommand("character_get", _connection);

                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@user_account_id_in", userAccountId);

                DataTable characters = new DataTable();

                // Use MySqlDataAdapter to fill the DataTable with the results of the stored procedure
                using (MySqlDataAdapter adapter = new MySqlDataAdapter(command))
                {
                    adapter.Fill(characters);
                }

                return characters;
            }
            finally
            {
                _connection.Close();
            }
        }
        public int FindCharacterByName(string name)
        {
            _connection.Open();

            try
            {
                MySqlCommand cmd = new MySqlCommand("character_find_by_name", _connection);

                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("character_name_in", name);

                object result = cmd.ExecuteScalar();

                if (result == null || result == DBNull.Value)
                {
                    return -1;
                }

                return Convert.ToInt32(result);
            }
            finally
            {
                _connection.Close();
            }
        }

        public bool CreateCharacter(string name, int userAccountId)
        {
            try
            {
                _connection.Open();

                MySqlCommand command =
                    new MySqlCommand("character_create", _connection);

                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@name_in", name);
                command.Parameters.AddWithValue("@user_account_id_in", userAccountId);

                command.ExecuteNonQuery();
                return true;
            }

            catch (MySqlException ex)
            {
                Console.WriteLine($"Error creating character: {ex.Message}");
                return false;
            }
            finally
            {
                _connection.Close();
            }
        }

        public bool DeleteCharacter(int characterId)
        {
            try
            {
                _connection.Open();

                MySqlCommand command = new MySqlCommand("character_delete", _connection);

                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@player_character_id_in", characterId);

                command.ExecuteNonQuery();
                return true;
            }
            finally
            {
                _connection.Close();
            }
        }

        public void PlayCharacter(int characterId)
        {
            try
            {
                _connection.Open();

                MySqlCommand command =
                    new MySqlCommand("character_play", _connection);

                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@player_character_id_in", characterId);

                command.ExecuteNonQuery();
            }
            finally
            {
                _connection.Close();
            }
        }

        public DataTable GetParty(int characterId)
        {
            DataTable table = new DataTable();

            _connection.Open();

            try
            {
                MySqlCommand command = new MySqlCommand("party_get", _connection);

                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("player_character_id_in", characterId);

                MySqlDataAdapter adapter = new MySqlDataAdapter(command);
                adapter.Fill(table);
            }
            finally
            {
                _connection.Close();
            }

            return table;
        }

        public void LogoutCharacter(int characterId)
        {
            _connection.Open();

            try
            {
                MySqlCommand cmd = new MySqlCommand("character_logout", _connection);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("player_character_id_in", characterId);
                cmd.ExecuteNonQuery();
            }
            finally
            {
                _connection.Close();
            }
        }

        public DataTable GetPartyInvites(int characterId)
        {
            DataTable invites = new DataTable();

            _connection.Open();

            try
            {
                MySqlCommand cmd = new MySqlCommand(
                    "party_invites_get", _connection);

                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue(
                    "player_character_id_in", characterId);

                MySqlDataAdapter adapter = new MySqlDataAdapter(cmd);
                adapter.Fill(invites);
            }
            finally
            {
                _connection.Close();
            }

            return invites;
        }

        public void SendPartyInvite(int partyId, int inviterCharacterId, int inviteeCharacterId)
        {
            _connection.Open();
            try
            {
                MySqlCommand cmd = new MySqlCommand(
                    "party_invite", _connection);

                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("party_id_in", partyId);
                cmd.Parameters.AddWithValue("inviter_character_id_in", inviterCharacterId);
                cmd.Parameters.AddWithValue("invitee_character_id_in", inviteeCharacterId);

                cmd.ExecuteNonQuery();
            }
            finally
            {
                _connection.Close();
            }
        }
        public void AddPlayerToParty(int partyId, int characterId)
        {
            _connection.Open();
            try
            {
                MySqlCommand command = new MySqlCommand("party_add_player", _connection);
                command.CommandType = CommandType.StoredProcedure;

                command.Parameters.AddWithValue("party_id_in", partyId);
                command.Parameters.AddWithValue("player_character_id_in", characterId);

                command.ExecuteNonQuery();
            }
            finally
            {
                _connection.Close();
            }
        }

        public void RemovePlayerFromParty(int characterId)
        {
            _connection.Open();
            try
            {
                MySqlCommand command = new MySqlCommand(
                    "party_remove_player", _connection);

                command.CommandType = CommandType.StoredProcedure;

                command.Parameters.AddWithValue("player_character_id_in", characterId);
                command.Parameters.AddWithValue("destination_party_id_in", DBNull.Value);

                command.ExecuteNonQuery();
            }
            finally
            {
                _connection.Close();
            }
        }


        public void SendMessage(int characterId, string contents)
        {
            _connection.Open();
            try
            {
                MySqlCommand command = new MySqlCommand("party_send_message", _connection);

                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("player_character_id_in", characterId);
                command.Parameters.AddWithValue("contents_in", contents);

                command.ExecuteNonQuery();
            }
            finally
            {
                _connection.Close();
            }
        }


        public DataTable GetMessages(int characterId)
        {
            DataTable table = new DataTable();
            _connection.Open();
            try
            {
                MySqlCommand command = new MySqlCommand("party_get_messages", _connection);
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("player_character_id_in", characterId);

                MySqlDataAdapter adapter = new MySqlDataAdapter(command);
                adapter.Fill(table);
            }
            finally
            {
                _connection.Close();
            }
            return table;
        }

        public DataTable GetRoom(int characterId)
        {
            DataTable table = new DataTable();
            _connection.Open();
            try
            {
                MySqlCommand command = new MySqlCommand(
                    "room_get", _connection);

                command.CommandType = CommandType.StoredProcedure;

                command.Parameters.AddWithValue("player_character_id_in", characterId);

                MySqlDataAdapter adapter = new MySqlDataAdapter(command);
                adapter.Fill(table);
            }
            finally
            {
                _connection.Close();
            }
            return table;
        }


        public string MoveCharacter(int characterId, string direction)
        {
            string result = "";
            _connection.Open();
            try
            {
                MySqlCommand cmd = new MySqlCommand("gameplay_move_in_direction", _connection);

                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("player_character_id_in", characterId);
                cmd.Parameters.AddWithValue("direction_in", direction);

                result = cmd.ExecuteScalar().ToString();
            }
            finally
            {
                _connection.Close();
            }

            return result;
        }
        public DataTable GetInventory(int characterId)
        {
            _connection.Open();
            try
            {
                MySqlCommand cmd = new MySqlCommand("inventory_get", _connection);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("player_character_id_in", characterId);
                cmd.Parameters.AddWithValue("inventory_type_in", "carried");

                DataTable table = new DataTable();
                table.Load(cmd.ExecuteReader());
                return table;
            }
            finally
            {
                _connection.Close();
            }
        }

        public void PickUpItem(int characterId, long entityId)
        {
            _connection.Open();
            try
            {
                MySqlCommand cmd = new MySqlCommand("item_pick_up", _connection);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("player_character_id_in", characterId);
                cmd.Parameters.AddWithValue("entity_instance_id_in", entityId);
                cmd.ExecuteNonQuery();
            }
            finally
            {
                _connection.Close();
            }
        }

        public void DropItem(int characterId, int slotNo)
        {
            _connection.Open();
            try
            {
                MySqlCommand cmd = new MySqlCommand("inventory_drop", _connection);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("player_character_id_in", characterId);
                cmd.Parameters.AddWithValue("slot_no_in", slotNo);
                cmd.ExecuteNonQuery();
            }
            finally
            {
                _connection.Close();
            }
        }
        public void ToggleReady(int characterId)
        {
            _connection.Open();
            try
            {
                MySqlCommand cmd = new MySqlCommand("party_toggle_ready", _connection);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("player_character_id_in", characterId);
                cmd.ExecuteNonQuery();
            }
            finally
            {
                _connection.Close();
            }
        }
        public void NavigateDoorway(int characterId)
        {
            _connection.Open();
            try
            {
                MySqlCommand cmd = new MySqlCommand("gameplay_navigate_doorway", _connection);

                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("player_character_id_in", characterId);

                cmd.ExecuteNonQuery();
            }
            finally
            {
                _connection.Close();
            }
        }
        public DataTable GetScores(int characterId)
        {
            _connection.Open();
            try
            {
                MySqlCommand cmd = new MySqlCommand("score_get", _connection);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("player_character_id_in", characterId);

                DataTable table = new DataTable();
                table.Load(cmd.ExecuteReader());
                return table;
            }
            finally
            {
                _connection.Close();
            }
        }
    }
}