using System;
using System.Drawing;
using System.Windows.Forms;
using System.Threading;
using System.Threading.Tasks;
using FireSharp.Config;
using FireSharp.Interfaces;
using FireSharp.Response;

public partial class Form1 : Form
{
    private static IFirebaseClient client;
    private bool isRunning = false;

    private string pythonPath = "C:\\Users\\kotor\\Documents\\LinkStart\\LinkStartPython\\";
    private CancellationTokenSource cancellationTokenSource;

    public Form1()
    {
        InitializeComponent();
        btnStart.Click += BtnStart_Click;
        KeyPreview = true;
        KeyDown += Form1_KeyDown;
    }

    private async void BtnStart_Click(object sender, EventArgs e)
    {
        if (!isRunning)
        {
            btnStart.Enabled = false;
            lblStatus.Text = "Đang kết nối...";
            
            isRunning = true;
            cancellationTokenSource = new CancellationTokenSource();

            IFirebaseConfig config = new FirebaseConfig
            {
                AuthSecret = "y5KYvYGhHei338L0jIWmgHhR5B4oIEs9kybuky01",
                BasePath = "https://test-e61cd-default-rtdb.asia-southeast1.firebasedatabase.app/"
            };

            client = new FireSharp.FirebaseClient(config);

            if (client != null)
            {
                lblStatus.Text = "Đã kết nối. Đang chạy...";
                btnStart.Text = "ĐANG CHẠY";
                btnStart.BackColor = Color.FromArgb(76, 175, 80);
                await RunSlideControl(cancellationTokenSource.Token);
            }
            else
            {
                lblStatus.Text = "Kết nối thất bại!";
                btnStart.Enabled = true;
                isRunning = false;
            }
        }
    }

    private async Task RunSlideControl(CancellationToken token)
    {
        try
        {
            while (!token.IsCancellationRequested)
            {
                FirebaseResponse slideResponse = await client.GetAsync("slide");
                FirebaseResponse screenResponse = await client.GetAsync("screen");
                
                int slideValue = slideResponse.ResultAs<int>();
                string screenValue = screenResponse.ResultAs<string>();

                if (slideValue == 1)
                {
                    SendKeys.SendWait("{RIGHT}");
                    await client.SetAsync("slide", -1);
                }
                else if (slideValue == 0)
                {
                    SendKeys.SendWait("{LEFT}");
                    await client.SetAsync("slide", -1);
                }

                if (screenValue == "demo")
                {
                    System.Diagnostics.Process process = new System.Diagnostics.Process();
                    process.StartInfo.FileName = "python";
                    process.StartInfo.Arguments = pythonPath + "powerpoint_handler.py";
                    process.StartInfo.UseShellExecute = false;
                    process.StartInfo.RedirectStandardOutput = true;
                    process.Start();
                    
                    await client.SetAsync("screen", "");
                }
                else if (screenValue == "slide")
                {
                    System.Diagnostics.Process process = new System.Diagnostics.Process();
                    process.StartInfo.FileName = "python";
                    process.StartInfo.Arguments = pythonPath + "open_powerpoint_slide.py";
                    process.StartInfo.UseShellExecute = false;
                    process.StartInfo.RedirectStandardOutput = true;
                    process.Start();
                    
                    await client.SetAsync("screen", "");
                }

                await Task.Delay(100, token);
            }
        }
        catch (OperationCanceledException)
        {
            lblStatus.Text = "Đã dừng chương trình";
            btnStart.Text = "BẮT ĐẦU";
            btnStart.BackColor = Color.FromArgb(0, 122, 204);
            btnStart.Enabled = true;
        }
    }

    private void Form1_KeyDown(object sender, KeyEventArgs e)
    {
        if (e.Control && e.Shift && e.KeyCode == Keys.X)
        {
            if (isRunning)
            {
                cancellationTokenSource?.Cancel();
                isRunning = false;
            }
        }
    }
} 