namespace CavesOfKharst.Forms
{
    partial class FormGame
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            components = new System.ComponentModel.Container();
            gridSpacer = new TableLayoutPanel();
            gridRoom = new TableLayoutPanel();
            tableLayoutPanel1 = new TableLayoutPanel();
            label2 = new Label();
            tableLayoutPanel14 = new TableLayoutPanel();
            btnViewInvites = new Button();
            btnInvite = new Button();
            tableLayoutPanel2 = new TableLayoutPanel();
            btnKickPlayer4 = new Button();
            btnKickPlayer3 = new Button();
            btnKickPlayer2 = new Button();
            btnKickPlayer1 = new Button();
            lblPlayer4Score = new Label();
            lblPlayer3Score = new Label();
            lblPlayer2Score = new Label();
            lblPlayer1Score = new Label();
            lblPlayer1Name = new Label();
            lblPlayer2Name = new Label();
            lblPlayer3Name = new Label();
            lblPlayer4Name = new Label();
            label1 = new Label();
            tableLayoutPanel11 = new TableLayoutPanel();
            btnSend = new Button();
            textMessage = new TextBox();
            textChat = new RichTextBox();
            tableLayoutPanel3 = new TableLayoutPanel();
            tableLayoutPanel5 = new TableLayoutPanel();
            tableLayoutPanel12 = new TableLayoutPanel();
            btnEnterDoor = new Button();
            btnPickup = new Button();
            label13 = new Label();
            label10 = new Label();
            tableLayoutPanel4 = new TableLayoutPanel();
            btnMoveUp = new Button();
            btnMoveLeft = new Button();
            btnMoveDown = new Button();
            btnMoveRight = new Button();
            label9 = new Label();
            gridInventory = new TableLayoutPanel();
            tableLayoutPanel6 = new TableLayoutPanel();
            tableLayoutPanel13 = new TableLayoutPanel();
            lblInventory = new Label();
            tableLayoutPanel7 = new TableLayoutPanel();
            tableLayoutPanel8 = new TableLayoutPanel();
            btnLogout = new Button();
            btnReady = new Button();
            tableLayoutPanel10 = new TableLayoutPanel();
            label11 = new Label();
            label12 = new Label();
            lblName = new Label();
            tableLayoutPanel9 = new TableLayoutPanel();
            refreshTimer = new System.Windows.Forms.Timer(components);
            gridSpacer.SuspendLayout();
            tableLayoutPanel1.SuspendLayout();
            tableLayoutPanel14.SuspendLayout();
            tableLayoutPanel2.SuspendLayout();
            tableLayoutPanel11.SuspendLayout();
            tableLayoutPanel3.SuspendLayout();
            tableLayoutPanel5.SuspendLayout();
            tableLayoutPanel12.SuspendLayout();
            tableLayoutPanel4.SuspendLayout();
            tableLayoutPanel6.SuspendLayout();
            tableLayoutPanel13.SuspendLayout();
            tableLayoutPanel7.SuspendLayout();
            tableLayoutPanel8.SuspendLayout();
            tableLayoutPanel10.SuspendLayout();
            tableLayoutPanel9.SuspendLayout();
            SuspendLayout();
            // 
            // gridSpacer
            // 
            gridSpacer.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            gridSpacer.ColumnCount = 3;
            gridSpacer.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 50F));
            gridSpacer.ColumnStyles.Add(new ColumnStyle(SizeType.Absolute, 420F));
            gridSpacer.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 50F));
            gridSpacer.Controls.Add(gridRoom, 1, 1);
            gridSpacer.Location = new Point(3, 3);
            gridSpacer.Name = "gridSpacer";
            gridSpacer.RowCount = 3;
            gridSpacer.RowStyles.Add(new RowStyle(SizeType.Percent, 50F));
            gridSpacer.RowStyles.Add(new RowStyle(SizeType.Absolute, 540F));
            gridSpacer.RowStyles.Add(new RowStyle(SizeType.Percent, 50F));
            gridSpacer.Size = new Size(760, 583);
            gridSpacer.TabIndex = 0;
            // 
            // gridRoom
            // 
            gridRoom.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            gridRoom.ColumnCount = 7;
            gridRoom.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 14.2857113F));
            gridRoom.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 14.2857151F));
            gridRoom.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 14.2857151F));
            gridRoom.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 14.2857151F));
            gridRoom.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 14.2857151F));
            gridRoom.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 14.2857151F));
            gridRoom.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 14.2857151F));
            gridRoom.Location = new Point(173, 24);
            gridRoom.Name = "gridRoom";
            gridRoom.RowCount = 9;
            gridRoom.RowStyles.Add(new RowStyle(SizeType.Percent, 11.11111F));
            gridRoom.RowStyles.Add(new RowStyle(SizeType.Percent, 11.1111107F));
            gridRoom.RowStyles.Add(new RowStyle(SizeType.Percent, 11.1111107F));
            gridRoom.RowStyles.Add(new RowStyle(SizeType.Percent, 11.1111107F));
            gridRoom.RowStyles.Add(new RowStyle(SizeType.Percent, 11.1111107F));
            gridRoom.RowStyles.Add(new RowStyle(SizeType.Percent, 11.1111107F));
            gridRoom.RowStyles.Add(new RowStyle(SizeType.Percent, 11.1111107F));
            gridRoom.RowStyles.Add(new RowStyle(SizeType.Percent, 11.1111107F));
            gridRoom.RowStyles.Add(new RowStyle(SizeType.Percent, 11.1111107F));
            gridRoom.Size = new Size(414, 534);
            gridRoom.TabIndex = 1;
            // 
            // tableLayoutPanel1
            // 
            tableLayoutPanel1.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            tableLayoutPanel1.ColumnCount = 1;
            tableLayoutPanel1.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 100F));
            tableLayoutPanel1.Controls.Add(label2, 0, 3);
            tableLayoutPanel1.Controls.Add(tableLayoutPanel14, 0, 2);
            tableLayoutPanel1.Controls.Add(tableLayoutPanel2, 0, 1);
            tableLayoutPanel1.Controls.Add(label1, 0, 0);
            tableLayoutPanel1.Controls.Add(tableLayoutPanel11, 0, 5);
            tableLayoutPanel1.Controls.Add(textChat, 0, 4);
            tableLayoutPanel1.Location = new Point(3, 183);
            tableLayoutPanel1.Name = "tableLayoutPanel1";
            tableLayoutPanel1.RightToLeft = RightToLeft.No;
            tableLayoutPanel1.RowCount = 6;
            tableLayoutPanel1.RowStyles.Add(new RowStyle(SizeType.Absolute, 40F));
            tableLayoutPanel1.RowStyles.Add(new RowStyle(SizeType.Absolute, 150F));
            tableLayoutPanel1.RowStyles.Add(new RowStyle(SizeType.Absolute, 50F));
            tableLayoutPanel1.RowStyles.Add(new RowStyle(SizeType.Absolute, 40F));
            tableLayoutPanel1.RowStyles.Add(new RowStyle(SizeType.Percent, 100F));
            tableLayoutPanel1.RowStyles.Add(new RowStyle(SizeType.Absolute, 35F));
            tableLayoutPanel1.Size = new Size(406, 397);
            tableLayoutPanel1.TabIndex = 1;
            // 
            // label2
            // 
            label2.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            label2.AutoSize = true;
            label2.Font = new Font("Segoe UI", 15.75F, FontStyle.Bold, GraphicsUnit.Point, 0);
            label2.Location = new Point(3, 240);
            label2.Name = "label2";
            label2.Size = new Size(400, 40);
            label2.TabIndex = 13;
            label2.Text = "Chat";
            label2.TextAlign = ContentAlignment.MiddleCenter;
            // 
            // tableLayoutPanel14
            // 
            tableLayoutPanel14.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            tableLayoutPanel14.ColumnCount = 2;
            tableLayoutPanel14.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 50F));
            tableLayoutPanel14.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 50F));
            tableLayoutPanel14.Controls.Add(btnViewInvites, 0, 0);
            tableLayoutPanel14.Controls.Add(btnInvite, 1, 0);
            tableLayoutPanel14.Location = new Point(3, 193);
            tableLayoutPanel14.Name = "tableLayoutPanel14";
            tableLayoutPanel14.RowCount = 1;
            tableLayoutPanel14.RowStyles.Add(new RowStyle(SizeType.Percent, 50F));
            tableLayoutPanel14.Size = new Size(400, 44);
            tableLayoutPanel14.TabIndex = 2;
            // 
            // btnViewInvites
            // 
            btnViewInvites.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            btnViewInvites.BackColor = Color.White;
            btnViewInvites.Font = new Font("Segoe UI", 15.75F, FontStyle.Regular, GraphicsUnit.Point, 0);
            btnViewInvites.Location = new Point(3, 3);
            btnViewInvites.Name = "btnViewInvites";
            btnViewInvites.Size = new Size(194, 38);
            btnViewInvites.TabIndex = 13;
            btnViewInvites.Text = "View Invites";
            btnViewInvites.UseVisualStyleBackColor = false;
            btnViewInvites.Click += btnViewInvites_Click;
            // 
            // btnInvite
            // 
            btnInvite.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            btnInvite.BackColor = Color.White;
            btnInvite.Font = new Font("Segoe UI", 15.75F, FontStyle.Regular, GraphicsUnit.Point, 0);
            btnInvite.Location = new Point(203, 3);
            btnInvite.Name = "btnInvite";
            btnInvite.Size = new Size(194, 38);
            btnInvite.TabIndex = 12;
            btnInvite.Text = "Invite Character";
            btnInvite.UseVisualStyleBackColor = false;
            btnInvite.Click += btnInvite_Click;
            // 
            // tableLayoutPanel2
            // 
            tableLayoutPanel2.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            tableLayoutPanel2.ColumnCount = 3;
            tableLayoutPanel2.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 50F));
            tableLayoutPanel2.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 50F));
            tableLayoutPanel2.ColumnStyles.Add(new ColumnStyle(SizeType.Absolute, 100F));
            tableLayoutPanel2.Controls.Add(btnKickPlayer4, 2, 3);
            tableLayoutPanel2.Controls.Add(btnKickPlayer3, 2, 2);
            tableLayoutPanel2.Controls.Add(btnKickPlayer2, 2, 1);
            tableLayoutPanel2.Controls.Add(btnKickPlayer1, 2, 0);
            tableLayoutPanel2.Controls.Add(lblPlayer4Score, 1, 3);
            tableLayoutPanel2.Controls.Add(lblPlayer3Score, 1, 2);
            tableLayoutPanel2.Controls.Add(lblPlayer2Score, 1, 1);
            tableLayoutPanel2.Controls.Add(lblPlayer1Score, 1, 0);
            tableLayoutPanel2.Controls.Add(lblPlayer1Name, 0, 0);
            tableLayoutPanel2.Controls.Add(lblPlayer2Name, 0, 1);
            tableLayoutPanel2.Controls.Add(lblPlayer3Name, 0, 2);
            tableLayoutPanel2.Controls.Add(lblPlayer4Name, 0, 3);
            tableLayoutPanel2.Location = new Point(3, 43);
            tableLayoutPanel2.Name = "tableLayoutPanel2";
            tableLayoutPanel2.RowCount = 4;
            tableLayoutPanel2.RowStyles.Add(new RowStyle(SizeType.Percent, 25F));
            tableLayoutPanel2.RowStyles.Add(new RowStyle(SizeType.Percent, 25F));
            tableLayoutPanel2.RowStyles.Add(new RowStyle(SizeType.Percent, 25F));
            tableLayoutPanel2.RowStyles.Add(new RowStyle(SizeType.Percent, 25F));
            tableLayoutPanel2.Size = new Size(400, 144);
            tableLayoutPanel2.TabIndex = 2;
            // 
            // btnKickPlayer4
            // 
            btnKickPlayer4.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            btnKickPlayer4.BackColor = Color.White;
            btnKickPlayer4.Font = new Font("Segoe UI", 9F, FontStyle.Regular, GraphicsUnit.Point, 0);
            btnKickPlayer4.Location = new Point(303, 111);
            btnKickPlayer4.Name = "btnKickPlayer4";
            btnKickPlayer4.Size = new Size(94, 30);
            btnKickPlayer4.TabIndex = 11;
            btnKickPlayer4.Text = "Kick";
            btnKickPlayer4.UseVisualStyleBackColor = false;
            btnKickPlayer4.Click += btnKickPlayer4_Click;
            // 
            // btnKickPlayer3
            // 
            btnKickPlayer3.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            btnKickPlayer3.BackColor = Color.White;
            btnKickPlayer3.Font = new Font("Segoe UI", 9F, FontStyle.Regular, GraphicsUnit.Point, 0);
            btnKickPlayer3.Location = new Point(303, 75);
            btnKickPlayer3.Name = "btnKickPlayer3";
            btnKickPlayer3.Size = new Size(94, 30);
            btnKickPlayer3.TabIndex = 10;
            btnKickPlayer3.Text = "Kick";
            btnKickPlayer3.UseVisualStyleBackColor = false;
            btnKickPlayer3.Click += btnKickPlayer3_Click;
            // 
            // btnKickPlayer2
            // 
            btnKickPlayer2.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            btnKickPlayer2.BackColor = Color.White;
            btnKickPlayer2.Font = new Font("Segoe UI", 9F, FontStyle.Regular, GraphicsUnit.Point, 0);
            btnKickPlayer2.Location = new Point(303, 39);
            btnKickPlayer2.Name = "btnKickPlayer2";
            btnKickPlayer2.Size = new Size(94, 30);
            btnKickPlayer2.TabIndex = 9;
            btnKickPlayer2.Text = "Kick";
            btnKickPlayer2.UseVisualStyleBackColor = false;
            btnKickPlayer2.Click += btnKickPlayer2_Click;
            // 
            // btnKickPlayer1
            // 
            btnKickPlayer1.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            btnKickPlayer1.BackColor = Color.White;
            btnKickPlayer1.Font = new Font("Segoe UI", 9F, FontStyle.Regular, GraphicsUnit.Point, 0);
            btnKickPlayer1.Location = new Point(303, 3);
            btnKickPlayer1.Name = "btnKickPlayer1";
            btnKickPlayer1.Size = new Size(94, 30);
            btnKickPlayer1.TabIndex = 8;
            btnKickPlayer1.Text = "Kick";
            btnKickPlayer1.UseVisualStyleBackColor = false;
            btnKickPlayer1.Click += btnKickPlayer1_Click;
            // 
            // lblPlayer4Score
            // 
            lblPlayer4Score.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            lblPlayer4Score.AutoSize = true;
            lblPlayer4Score.Location = new Point(153, 108);
            lblPlayer4Score.Name = "lblPlayer4Score";
            lblPlayer4Score.Size = new Size(144, 36);
            lblPlayer4Score.TabIndex = 7;
            lblPlayer4Score.Text = "Player4 Score";
            lblPlayer4Score.TextAlign = ContentAlignment.MiddleCenter;
            // 
            // lblPlayer3Score
            // 
            lblPlayer3Score.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            lblPlayer3Score.AutoSize = true;
            lblPlayer3Score.Location = new Point(153, 72);
            lblPlayer3Score.Name = "lblPlayer3Score";
            lblPlayer3Score.Size = new Size(144, 36);
            lblPlayer3Score.TabIndex = 6;
            lblPlayer3Score.Text = "Player3 Score";
            lblPlayer3Score.TextAlign = ContentAlignment.MiddleCenter;
            // 
            // lblPlayer2Score
            // 
            lblPlayer2Score.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            lblPlayer2Score.AutoSize = true;
            lblPlayer2Score.Location = new Point(153, 36);
            lblPlayer2Score.Name = "lblPlayer2Score";
            lblPlayer2Score.Size = new Size(144, 36);
            lblPlayer2Score.TabIndex = 5;
            lblPlayer2Score.Text = "Player2 Score";
            lblPlayer2Score.TextAlign = ContentAlignment.MiddleCenter;
            // 
            // lblPlayer1Score
            // 
            lblPlayer1Score.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            lblPlayer1Score.AutoSize = true;
            lblPlayer1Score.Location = new Point(153, 0);
            lblPlayer1Score.Name = "lblPlayer1Score";
            lblPlayer1Score.Size = new Size(144, 36);
            lblPlayer1Score.TabIndex = 4;
            lblPlayer1Score.Text = "Player1 Score";
            lblPlayer1Score.TextAlign = ContentAlignment.MiddleCenter;
            // 
            // lblPlayer1Name
            // 
            lblPlayer1Name.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            lblPlayer1Name.AutoSize = true;
            lblPlayer1Name.Location = new Point(3, 0);
            lblPlayer1Name.Name = "lblPlayer1Name";
            lblPlayer1Name.Size = new Size(144, 36);
            lblPlayer1Name.TabIndex = 0;
            lblPlayer1Name.Text = "Player1 Name";
            lblPlayer1Name.TextAlign = ContentAlignment.MiddleCenter;
            // 
            // lblPlayer2Name
            // 
            lblPlayer2Name.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            lblPlayer2Name.AutoSize = true;
            lblPlayer2Name.Location = new Point(3, 36);
            lblPlayer2Name.Name = "lblPlayer2Name";
            lblPlayer2Name.Size = new Size(144, 36);
            lblPlayer2Name.TabIndex = 1;
            lblPlayer2Name.Text = "Player2 Name";
            lblPlayer2Name.TextAlign = ContentAlignment.MiddleCenter;
            // 
            // lblPlayer3Name
            // 
            lblPlayer3Name.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            lblPlayer3Name.AutoSize = true;
            lblPlayer3Name.Location = new Point(3, 72);
            lblPlayer3Name.Name = "lblPlayer3Name";
            lblPlayer3Name.Size = new Size(144, 36);
            lblPlayer3Name.TabIndex = 2;
            lblPlayer3Name.Text = "Player3 Name";
            lblPlayer3Name.TextAlign = ContentAlignment.MiddleCenter;
            // 
            // lblPlayer4Name
            // 
            lblPlayer4Name.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            lblPlayer4Name.AutoSize = true;
            lblPlayer4Name.Location = new Point(3, 108);
            lblPlayer4Name.Name = "lblPlayer4Name";
            lblPlayer4Name.Size = new Size(144, 36);
            lblPlayer4Name.TabIndex = 3;
            lblPlayer4Name.Text = "Player4 Name";
            lblPlayer4Name.TextAlign = ContentAlignment.MiddleCenter;
            // 
            // label1
            // 
            label1.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            label1.AutoSize = true;
            label1.Font = new Font("Segoe UI", 15.75F, FontStyle.Bold, GraphicsUnit.Point, 0);
            label1.Location = new Point(3, 0);
            label1.Name = "label1";
            label1.Size = new Size(400, 40);
            label1.TabIndex = 3;
            label1.Text = "Players";
            label1.TextAlign = ContentAlignment.MiddleCenter;
            // 
            // tableLayoutPanel11
            // 
            tableLayoutPanel11.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            tableLayoutPanel11.ColumnCount = 2;
            tableLayoutPanel11.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 75.53191F));
            tableLayoutPanel11.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 24.4680843F));
            tableLayoutPanel11.Controls.Add(btnSend, 1, 0);
            tableLayoutPanel11.Controls.Add(textMessage, 0, 0);
            tableLayoutPanel11.Location = new Point(3, 365);
            tableLayoutPanel11.Name = "tableLayoutPanel11";
            tableLayoutPanel11.RowCount = 1;
            tableLayoutPanel11.RowStyles.Add(new RowStyle(SizeType.Percent, 50F));
            tableLayoutPanel11.RowStyles.Add(new RowStyle(SizeType.Percent, 50F));
            tableLayoutPanel11.RowStyles.Add(new RowStyle(SizeType.Absolute, 20F));
            tableLayoutPanel11.RowStyles.Add(new RowStyle(SizeType.Absolute, 20F));
            tableLayoutPanel11.RowStyles.Add(new RowStyle(SizeType.Absolute, 20F));
            tableLayoutPanel11.RowStyles.Add(new RowStyle(SizeType.Absolute, 20F));
            tableLayoutPanel11.RowStyles.Add(new RowStyle(SizeType.Absolute, 20F));
            tableLayoutPanel11.RowStyles.Add(new RowStyle(SizeType.Absolute, 20F));
            tableLayoutPanel11.RowStyles.Add(new RowStyle(SizeType.Absolute, 20F));
            tableLayoutPanel11.RowStyles.Add(new RowStyle(SizeType.Absolute, 20F));
            tableLayoutPanel11.RowStyles.Add(new RowStyle(SizeType.Absolute, 20F));
            tableLayoutPanel11.RowStyles.Add(new RowStyle(SizeType.Absolute, 20F));
            tableLayoutPanel11.RowStyles.Add(new RowStyle(SizeType.Absolute, 20F));
            tableLayoutPanel11.RowStyles.Add(new RowStyle(SizeType.Absolute, 20F));
            tableLayoutPanel11.RowStyles.Add(new RowStyle(SizeType.Absolute, 20F));
            tableLayoutPanel11.RowStyles.Add(new RowStyle(SizeType.Absolute, 20F));
            tableLayoutPanel11.RowStyles.Add(new RowStyle(SizeType.Absolute, 20F));
            tableLayoutPanel11.RowStyles.Add(new RowStyle(SizeType.Absolute, 20F));
            tableLayoutPanel11.RowStyles.Add(new RowStyle(SizeType.Absolute, 20F));
            tableLayoutPanel11.RowStyles.Add(new RowStyle(SizeType.Absolute, 20F));
            tableLayoutPanel11.RowStyles.Add(new RowStyle(SizeType.Absolute, 20F));
            tableLayoutPanel11.Size = new Size(400, 29);
            tableLayoutPanel11.TabIndex = 14;
            // 
            // btnSend
            // 
            btnSend.Anchor = AnchorStyles.Left | AnchorStyles.Right;
            btnSend.BackColor = Color.White;
            btnSend.Font = new Font("Segoe UI", 9F, FontStyle.Regular, GraphicsUnit.Point, 0);
            btnSend.Location = new Point(305, 3);
            btnSend.Name = "btnSend";
            btnSend.Size = new Size(92, 23);
            btnSend.TabIndex = 12;
            btnSend.Text = "Send";
            btnSend.UseVisualStyleBackColor = false;
            btnSend.Click += btnSend_Click;
            // 
            // textMessage
            // 
            textMessage.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            textMessage.Location = new Point(3, 3);
            textMessage.Name = "textMessage";
            textMessage.Size = new Size(296, 23);
            textMessage.TabIndex = 13;
            // 
            // textChat
            // 
            textChat.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            textChat.Location = new Point(3, 283);
            textChat.Name = "textChat";
            textChat.Size = new Size(400, 76);
            textChat.TabIndex = 15;
            textChat.Text = "";
            // 
            // tableLayoutPanel3
            // 
            tableLayoutPanel3.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            tableLayoutPanel3.ColumnCount = 1;
            tableLayoutPanel3.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 50F));
            tableLayoutPanel3.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 50F));
            tableLayoutPanel3.Controls.Add(tableLayoutPanel5, 0, 1);
            tableLayoutPanel3.Controls.Add(label9, 0, 0);
            tableLayoutPanel3.Location = new Point(3, 3);
            tableLayoutPanel3.Name = "tableLayoutPanel3";
            tableLayoutPanel3.RowCount = 2;
            tableLayoutPanel3.RowStyles.Add(new RowStyle(SizeType.Percent, 22.289156F));
            tableLayoutPanel3.RowStyles.Add(new RowStyle(SizeType.Percent, 77.7108459F));
            tableLayoutPanel3.RowStyles.Add(new RowStyle(SizeType.Absolute, 20F));
            tableLayoutPanel3.Size = new Size(342, 166);
            tableLayoutPanel3.TabIndex = 2;
            // 
            // tableLayoutPanel5
            // 
            tableLayoutPanel5.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            tableLayoutPanel5.ColumnCount = 2;
            tableLayoutPanel5.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 51.7857132F));
            tableLayoutPanel5.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 48.2142868F));
            tableLayoutPanel5.ColumnStyles.Add(new ColumnStyle(SizeType.Absolute, 62F));
            tableLayoutPanel5.Controls.Add(tableLayoutPanel12, 0, 1);
            tableLayoutPanel5.Controls.Add(label13, 0, 0);
            tableLayoutPanel5.Controls.Add(label10, 1, 0);
            tableLayoutPanel5.Controls.Add(tableLayoutPanel4, 1, 1);
            tableLayoutPanel5.Location = new Point(3, 40);
            tableLayoutPanel5.Name = "tableLayoutPanel5";
            tableLayoutPanel5.RowCount = 2;
            tableLayoutPanel5.RowStyles.Add(new RowStyle(SizeType.Percent, 24.8F));
            tableLayoutPanel5.RowStyles.Add(new RowStyle(SizeType.Percent, 75.2F));
            tableLayoutPanel5.Size = new Size(336, 123);
            tableLayoutPanel5.TabIndex = 2;
            // 
            // tableLayoutPanel12
            // 
            tableLayoutPanel12.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            tableLayoutPanel12.ColumnCount = 1;
            tableLayoutPanel12.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 33.3333321F));
            tableLayoutPanel12.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 33.3333321F));
            tableLayoutPanel12.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 33.3333321F));
            tableLayoutPanel12.Controls.Add(btnEnterDoor, 0, 0);
            tableLayoutPanel12.Controls.Add(btnPickup, 0, 1);
            tableLayoutPanel12.Location = new Point(3, 33);
            tableLayoutPanel12.Name = "tableLayoutPanel12";
            tableLayoutPanel12.RowCount = 2;
            tableLayoutPanel12.RowStyles.Add(new RowStyle(SizeType.Percent, 50F));
            tableLayoutPanel12.RowStyles.Add(new RowStyle(SizeType.Percent, 50F));
            tableLayoutPanel12.Size = new Size(168, 87);
            tableLayoutPanel12.TabIndex = 7;
            // 
            // btnEnterDoor
            // 
            btnEnterDoor.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            btnEnterDoor.Font = new Font("Segoe UI", 12F, FontStyle.Bold);
            btnEnterDoor.Location = new Point(3, 3);
            btnEnterDoor.Name = "btnEnterDoor";
            btnEnterDoor.Size = new Size(162, 37);
            btnEnterDoor.TabIndex = 4;
            btnEnterDoor.Text = "Enter Door ( E )";
            btnEnterDoor.UseVisualStyleBackColor = true;
            btnEnterDoor.Click += btnEnterDoor_Click;
            // 
            // btnPickup
            // 
            btnPickup.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            btnPickup.Font = new Font("Segoe UI", 12F, FontStyle.Bold);
            btnPickup.Location = new Point(3, 46);
            btnPickup.Name = "btnPickup";
            btnPickup.Size = new Size(162, 38);
            btnPickup.TabIndex = 3;
            btnPickup.Text = "Pickup ( Q )";
            btnPickup.UseVisualStyleBackColor = true;
            btnPickup.Click += btnPickup_Click;
            // 
            // label13
            // 
            label13.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            label13.AutoSize = true;
            label13.Font = new Font("Segoe UI", 15.75F, FontStyle.Regular, GraphicsUnit.Point, 0);
            label13.Location = new Point(3, 0);
            label13.Name = "label13";
            label13.Size = new Size(168, 30);
            label13.TabIndex = 6;
            label13.Text = "Game";
            label13.TextAlign = ContentAlignment.MiddleCenter;
            // 
            // label10
            // 
            label10.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            label10.AutoSize = true;
            label10.Font = new Font("Segoe UI", 15.75F, FontStyle.Regular, GraphicsUnit.Point, 0);
            label10.Location = new Point(177, 0);
            label10.Name = "label10";
            label10.Size = new Size(156, 30);
            label10.TabIndex = 5;
            label10.Text = "Movement";
            label10.TextAlign = ContentAlignment.MiddleCenter;
            // 
            // tableLayoutPanel4
            // 
            tableLayoutPanel4.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            tableLayoutPanel4.ColumnCount = 3;
            tableLayoutPanel4.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 33.3333321F));
            tableLayoutPanel4.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 33.3333321F));
            tableLayoutPanel4.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 33.3333321F));
            tableLayoutPanel4.Controls.Add(btnMoveUp, 1, 0);
            tableLayoutPanel4.Controls.Add(btnMoveLeft, 0, 1);
            tableLayoutPanel4.Controls.Add(btnMoveDown, 1, 1);
            tableLayoutPanel4.Controls.Add(btnMoveRight, 2, 1);
            tableLayoutPanel4.Location = new Point(177, 33);
            tableLayoutPanel4.Name = "tableLayoutPanel4";
            tableLayoutPanel4.RowCount = 2;
            tableLayoutPanel4.RowStyles.Add(new RowStyle(SizeType.Percent, 50F));
            tableLayoutPanel4.RowStyles.Add(new RowStyle(SizeType.Percent, 50F));
            tableLayoutPanel4.Size = new Size(156, 87);
            tableLayoutPanel4.TabIndex = 1;
            // 
            // btnMoveUp
            // 
            btnMoveUp.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            btnMoveUp.Font = new Font("Segoe UI", 12F, FontStyle.Bold);
            btnMoveUp.Location = new Point(55, 3);
            btnMoveUp.Name = "btnMoveUp";
            btnMoveUp.Size = new Size(46, 37);
            btnMoveUp.TabIndex = 0;
            btnMoveUp.Text = "W";
            btnMoveUp.UseVisualStyleBackColor = true;
            btnMoveUp.Click += btnMoveUp_Click;
            // 
            // btnMoveLeft
            // 
            btnMoveLeft.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            btnMoveLeft.Font = new Font("Segoe UI", 12F, FontStyle.Bold);
            btnMoveLeft.Location = new Point(3, 46);
            btnMoveLeft.Name = "btnMoveLeft";
            btnMoveLeft.Size = new Size(46, 38);
            btnMoveLeft.TabIndex = 1;
            btnMoveLeft.Text = "A";
            btnMoveLeft.UseVisualStyleBackColor = true;
            btnMoveLeft.Click += btnMoveLeft_Click;
            // 
            // btnMoveDown
            // 
            btnMoveDown.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            btnMoveDown.Font = new Font("Segoe UI", 12F, FontStyle.Bold);
            btnMoveDown.Location = new Point(55, 46);
            btnMoveDown.Name = "btnMoveDown";
            btnMoveDown.Size = new Size(46, 38);
            btnMoveDown.TabIndex = 2;
            btnMoveDown.Text = "S";
            btnMoveDown.UseVisualStyleBackColor = true;
            btnMoveDown.Click += btnMoveDown_Click;
            // 
            // btnMoveRight
            // 
            btnMoveRight.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            btnMoveRight.Font = new Font("Segoe UI", 12F, FontStyle.Bold);
            btnMoveRight.Location = new Point(107, 46);
            btnMoveRight.Name = "btnMoveRight";
            btnMoveRight.Size = new Size(46, 38);
            btnMoveRight.TabIndex = 3;
            btnMoveRight.Text = "D";
            btnMoveRight.UseVisualStyleBackColor = true;
            btnMoveRight.Click += btnMoveRight_Click;
            // 
            // label9
            // 
            label9.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            label9.AutoSize = true;
            label9.Font = new Font("Segoe UI", 15.75F, FontStyle.Bold, GraphicsUnit.Point, 0);
            label9.Location = new Point(3, 0);
            label9.Name = "label9";
            label9.Size = new Size(336, 37);
            label9.TabIndex = 4;
            label9.Text = "Controls";
            label9.TextAlign = ContentAlignment.MiddleCenter;
            // 
            // gridInventory
            // 
            gridInventory.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            gridInventory.ColumnCount = 8;
            gridInventory.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 12.5F));
            gridInventory.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 12.5F));
            gridInventory.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 12.5F));
            gridInventory.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 12.5F));
            gridInventory.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 12.5F));
            gridInventory.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 12.5F));
            gridInventory.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 12.5F));
            gridInventory.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 12.5F));
            gridInventory.Location = new Point(15, 14);
            gridInventory.Name = "gridInventory";
            gridInventory.RowCount = 1;
            gridInventory.RowStyles.Add(new RowStyle(SizeType.Percent, 100F));
            gridInventory.Size = new Size(794, 94);
            gridInventory.TabIndex = 1;
            // 
            // tableLayoutPanel6
            // 
            tableLayoutPanel6.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            tableLayoutPanel6.ColumnCount = 1;
            tableLayoutPanel6.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 50F));
            tableLayoutPanel6.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 50F));
            tableLayoutPanel6.Controls.Add(tableLayoutPanel13, 0, 1);
            tableLayoutPanel6.Controls.Add(lblInventory, 0, 0);
            tableLayoutPanel6.Location = new Point(351, 3);
            tableLayoutPanel6.Name = "tableLayoutPanel6";
            tableLayoutPanel6.RowCount = 2;
            tableLayoutPanel6.RowStyles.Add(new RowStyle(SizeType.Percent, 22.59887F));
            tableLayoutPanel6.RowStyles.Add(new RowStyle(SizeType.Percent, 77.40113F));
            tableLayoutPanel6.Size = new Size(830, 166);
            tableLayoutPanel6.TabIndex = 2;
            // 
            // tableLayoutPanel13
            // 
            tableLayoutPanel13.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            tableLayoutPanel13.ColumnCount = 3;
            tableLayoutPanel13.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 50F));
            tableLayoutPanel13.ColumnStyles.Add(new ColumnStyle(SizeType.Absolute, 800F));
            tableLayoutPanel13.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 50F));
            tableLayoutPanel13.Controls.Add(gridInventory, 1, 1);
            tableLayoutPanel13.Location = new Point(3, 40);
            tableLayoutPanel13.Name = "tableLayoutPanel13";
            tableLayoutPanel13.RowCount = 3;
            tableLayoutPanel13.RowStyles.Add(new RowStyle(SizeType.Percent, 50F));
            tableLayoutPanel13.RowStyles.Add(new RowStyle(SizeType.Absolute, 100F));
            tableLayoutPanel13.RowStyles.Add(new RowStyle(SizeType.Percent, 50F));
            tableLayoutPanel13.Size = new Size(824, 123);
            tableLayoutPanel13.TabIndex = 6;
            // 
            // lblInventory
            // 
            lblInventory.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            lblInventory.AutoSize = true;
            lblInventory.Font = new Font("Segoe UI", 15.75F, FontStyle.Bold, GraphicsUnit.Point, 0);
            lblInventory.Location = new Point(3, 0);
            lblInventory.Name = "lblInventory";
            lblInventory.Size = new Size(824, 37);
            lblInventory.TabIndex = 5;
            lblInventory.Text = "Inventory";
            lblInventory.TextAlign = ContentAlignment.MiddleCenter;
            // 
            // tableLayoutPanel7
            // 
            tableLayoutPanel7.ColumnCount = 2;
            tableLayoutPanel7.ColumnStyles.Add(new ColumnStyle(SizeType.Absolute, 348F));
            tableLayoutPanel7.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 100F));
            tableLayoutPanel7.Controls.Add(tableLayoutPanel3, 0, 0);
            tableLayoutPanel7.Controls.Add(tableLayoutPanel6, 1, 0);
            tableLayoutPanel7.Dock = DockStyle.Bottom;
            tableLayoutPanel7.Location = new Point(0, 589);
            tableLayoutPanel7.Name = "tableLayoutPanel7";
            tableLayoutPanel7.RowCount = 1;
            tableLayoutPanel7.RowStyles.Add(new RowStyle(SizeType.Percent, 100F));
            tableLayoutPanel7.Size = new Size(1184, 172);
            tableLayoutPanel7.TabIndex = 1;
            // 
            // tableLayoutPanel8
            // 
            tableLayoutPanel8.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            tableLayoutPanel8.ColumnCount = 1;
            tableLayoutPanel8.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 100F));
            tableLayoutPanel8.Controls.Add(btnLogout, 0, 0);
            tableLayoutPanel8.Controls.Add(tableLayoutPanel1, 0, 4);
            tableLayoutPanel8.Controls.Add(btnReady, 0, 3);
            tableLayoutPanel8.Controls.Add(tableLayoutPanel10, 0, 2);
            tableLayoutPanel8.Controls.Add(lblName, 0, 1);
            tableLayoutPanel8.Location = new Point(769, 3);
            tableLayoutPanel8.Name = "tableLayoutPanel8";
            tableLayoutPanel8.RowCount = 5;
            tableLayoutPanel8.RowStyles.Add(new RowStyle(SizeType.Absolute, 50F));
            tableLayoutPanel8.RowStyles.Add(new RowStyle(SizeType.Absolute, 40F));
            tableLayoutPanel8.RowStyles.Add(new RowStyle(SizeType.Absolute, 40F));
            tableLayoutPanel8.RowStyles.Add(new RowStyle(SizeType.Absolute, 50F));
            tableLayoutPanel8.RowStyles.Add(new RowStyle(SizeType.Percent, 100F));
            tableLayoutPanel8.Size = new Size(412, 583);
            tableLayoutPanel8.TabIndex = 1;
            // 
            // btnLogout
            // 
            btnLogout.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            btnLogout.BackColor = Color.FromArgb(255, 192, 192);
            btnLogout.Font = new Font("Segoe UI", 15.75F, FontStyle.Regular, GraphicsUnit.Point, 0);
            btnLogout.Location = new Point(3, 3);
            btnLogout.Name = "btnLogout";
            btnLogout.Size = new Size(406, 44);
            btnLogout.TabIndex = 7;
            btnLogout.Text = "Exit";
            btnLogout.UseVisualStyleBackColor = false;
            btnLogout.Click += btnLogout_Click;
            // 
            // btnReady
            // 
            btnReady.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            btnReady.BackColor = Color.FromArgb(255, 192, 192);
            btnReady.Font = new Font("Segoe UI", 15.75F, FontStyle.Regular, GraphicsUnit.Point, 0);
            btnReady.Location = new Point(3, 133);
            btnReady.Name = "btnReady";
            btnReady.Size = new Size(406, 44);
            btnReady.TabIndex = 6;
            btnReady.Text = "Ready?";
            btnReady.UseVisualStyleBackColor = false;
            btnReady.Click += btnReady_Click;
            // 
            // tableLayoutPanel10
            // 
            tableLayoutPanel10.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            tableLayoutPanel10.ColumnCount = 2;
            tableLayoutPanel10.ColumnStyles.Add(new ColumnStyle(SizeType.Absolute, 54F));
            tableLayoutPanel10.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 100F));
            tableLayoutPanel10.Controls.Add(label11, 0, 0);
            tableLayoutPanel10.Controls.Add(label12, 1, 0);
            tableLayoutPanel10.Location = new Point(3, 93);
            tableLayoutPanel10.Name = "tableLayoutPanel10";
            tableLayoutPanel10.RowCount = 1;
            tableLayoutPanel10.RowStyles.Add(new RowStyle(SizeType.Percent, 100F));
            tableLayoutPanel10.Size = new Size(406, 34);
            tableLayoutPanel10.TabIndex = 5;
            // 
            // label11
            // 
            label11.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            label11.AutoSize = true;
            label11.Font = new Font("Segoe UI", 15.75F, FontStyle.Bold, GraphicsUnit.Point, 0);
            label11.Location = new Point(3, 0);
            label11.Name = "label11";
            label11.Size = new Size(48, 34);
            label11.TabIndex = 5;
            label11.Text = "HP:";
            label11.TextAlign = ContentAlignment.MiddleCenter;
            // 
            // label12
            // 
            label12.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            label12.AutoSize = true;
            label12.Font = new Font("Segoe UI", 15.75F, FontStyle.Regular, GraphicsUnit.Point, 0);
            label12.Location = new Point(57, 0);
            label12.Name = "label12";
            label12.Size = new Size(346, 34);
            label12.TabIndex = 6;
            label12.Text = "0";
            label12.TextAlign = ContentAlignment.MiddleLeft;
            // 
            // lblName
            // 
            lblName.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            lblName.AutoSize = true;
            lblName.Font = new Font("Segoe UI", 15.75F, FontStyle.Bold, GraphicsUnit.Point, 0);
            lblName.Location = new Point(3, 50);
            lblName.Name = "lblName";
            lblName.Size = new Size(406, 40);
            lblName.TabIndex = 4;
            lblName.Text = "Name";
            lblName.TextAlign = ContentAlignment.MiddleCenter;
            // 
            // tableLayoutPanel9
            // 
            tableLayoutPanel9.ColumnCount = 2;
            tableLayoutPanel9.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 100F));
            tableLayoutPanel9.ColumnStyles.Add(new ColumnStyle(SizeType.Absolute, 418F));
            tableLayoutPanel9.Controls.Add(tableLayoutPanel8, 1, 0);
            tableLayoutPanel9.Controls.Add(gridSpacer, 0, 0);
            tableLayoutPanel9.Dock = DockStyle.Fill;
            tableLayoutPanel9.Location = new Point(0, 0);
            tableLayoutPanel9.Name = "tableLayoutPanel9";
            tableLayoutPanel9.RowCount = 1;
            tableLayoutPanel9.RowStyles.Add(new RowStyle(SizeType.Percent, 100F));
            tableLayoutPanel9.Size = new Size(1184, 589);
            tableLayoutPanel9.TabIndex = 1;
            // 
            // refreshTimer
            // 
            refreshTimer.Enabled = true;
            refreshTimer.Interval = 250;
            refreshTimer.Tick += refreshTimer_Tick;
            // 
            // FormGame
            // 
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(1184, 761);
            Controls.Add(tableLayoutPanel9);
            Controls.Add(tableLayoutPanel7);
            MinimumSize = new Size(1200, 800);
            Name = "FormGame";
            Text = "Caves of Kharst";
            FormClosing += FormGame_FormClosing;
            gridSpacer.ResumeLayout(false);
            tableLayoutPanel1.ResumeLayout(false);
            tableLayoutPanel1.PerformLayout();
            tableLayoutPanel14.ResumeLayout(false);
            tableLayoutPanel2.ResumeLayout(false);
            tableLayoutPanel2.PerformLayout();
            tableLayoutPanel11.ResumeLayout(false);
            tableLayoutPanel11.PerformLayout();
            tableLayoutPanel3.ResumeLayout(false);
            tableLayoutPanel3.PerformLayout();
            tableLayoutPanel5.ResumeLayout(false);
            tableLayoutPanel5.PerformLayout();
            tableLayoutPanel12.ResumeLayout(false);
            tableLayoutPanel4.ResumeLayout(false);
            tableLayoutPanel6.ResumeLayout(false);
            tableLayoutPanel6.PerformLayout();
            tableLayoutPanel13.ResumeLayout(false);
            tableLayoutPanel7.ResumeLayout(false);
            tableLayoutPanel8.ResumeLayout(false);
            tableLayoutPanel8.PerformLayout();
            tableLayoutPanel10.ResumeLayout(false);
            tableLayoutPanel10.PerformLayout();
            tableLayoutPanel9.ResumeLayout(false);
            ResumeLayout(false);
        }

        #endregion

        private TableLayoutPanel gridSpacer;
        private TableLayoutPanel tableLayoutPanel1;
        private TableLayoutPanel tableLayoutPanel2;
        private Label label1;
        private Label lblPlayer4Score;
        private Label lblPlayer3Score;
        private Label lblPlayer2Score;
        private Label lblPlayer1Score;
        private Label lblPlayer1Name;
        private Label lblPlayer2Name;
        private Label lblPlayer3Name;
        private Label lblPlayer4Name;
        private TableLayoutPanel tableLayoutPanel3;
        private Label label9;
        private TableLayoutPanel tableLayoutPanel4;
        private TableLayoutPanel tableLayoutPanel5;
        private Label label10;
        private Button btnMoveUp;
        private Button btnMoveLeft;
        private Button btnMoveDown;
        private Button btnMoveRight;
        private TableLayoutPanel gridInventory;
        private TableLayoutPanel tableLayoutPanel6;
        private Label lblInventory;
        private TableLayoutPanel tableLayoutPanel7;
        private TableLayoutPanel tableLayoutPanel8;
        private TableLayoutPanel tableLayoutPanel9;
        private TableLayoutPanel tableLayoutPanel10;
        private Label label12;
        private Label label11;
        private Label lblName;
        private TableLayoutPanel gridRoom;
        private Button btnReady;
        private TableLayoutPanel tableLayoutPanel12;
        private Button btnPickup;
        private Label label13;
        private Button btnLogout;
        private Button btnKickPlayer4;
        private Button btnKickPlayer3;
        private Button btnKickPlayer2;
        private Button btnKickPlayer1;
        private Button btnInvite;
        private Button btnEnterDoor;
        private TableLayoutPanel tableLayoutPanel13;
        private Label label2;
        private TableLayoutPanel tableLayoutPanel11;
        private Button btnSend;
        private TextBox textMessage;
        private RichTextBox textChat;
        private TableLayoutPanel tableLayoutPanel14;
        private Button btnViewInvites;
        private System.Windows.Forms.Timer refreshTimer;
    }
}