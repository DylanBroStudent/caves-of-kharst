namespace CavesOfKharst.Forms
{
    partial class FormSendInvite
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
            textSendInvite = new TextBox();
            btnSendInvite = new Button();
            label2 = new Label();
            SuspendLayout();
            // 
            // textSendInvite
            // 
            textSendInvite.Anchor = AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
            textSendInvite.Font = new Font("Segoe UI", 15.75F, FontStyle.Regular, GraphicsUnit.Point, 0);
            textSendInvite.Location = new Point(12, 44);
            textSendInvite.Name = "textSendInvite";
            textSendInvite.Size = new Size(225, 35);
            textSendInvite.TabIndex = 0;
            // 
            // btnSendInvite
            // 
            btnSendInvite.Anchor = AnchorStyles.Bottom | AnchorStyles.Right;
            btnSendInvite.Location = new Point(246, 44);
            btnSendInvite.Name = "btnSendInvite";
            btnSendInvite.Size = new Size(128, 35);
            btnSendInvite.TabIndex = 1;
            btnSendInvite.Text = "Send Invite";
            btnSendInvite.UseVisualStyleBackColor = true;
            btnSendInvite.Click += btnSendInvite_Click;
            // 
            // label2
            // 
            label2.AutoSize = true;
            label2.Font = new Font("Segoe UI", 15.75F, FontStyle.Regular, GraphicsUnit.Point, 0);
            label2.Location = new Point(12, 9);
            label2.Name = "label2";
            label2.Size = new Size(297, 30);
            label2.TabIndex = 3;
            label2.Text = "Enter character name to invite:";
            // 
            // FormSendInvite
            // 
            AutoScaleDimensions = new SizeF(7F, 15F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(384, 91);
            Controls.Add(label2);
            Controls.Add(btnSendInvite);
            Controls.Add(textSendInvite);
            MinimumSize = new Size(400, 130);
            Name = "FormSendInvite";
            Text = "Send Invite";
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion

        private TextBox textSendInvite;
        private Button btnSendInvite;
        private Label label2;
    }
}