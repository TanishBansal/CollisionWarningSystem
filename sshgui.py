import coloredlogs
from itertools import count
import logging
import logging.config
import paramiko
from PIL import Image, ImageTk
import tkinter as tk
from tkinter import filedialog , Label
import os
class ImageLabel(tk.Label):
    def load(self, im):
        if isinstance(im, str):
            im = Image.open(im)
        self.loc = 0
        self.frames = []

        try:
            for i in count(1):
                self.frames.append(ImageTk.PhotoImage(im.copy()))
                im.seek(i)
        except EOFError:
            pass

        try:
            self.delay = im.info['duration']
        except:
            self.delay = 10

        if len(self.frames) == 1:
            self.config(image=self.frames[0])
        else:
            self.next_frame()

    def unload(self):
        self.config(image=None)
        self.frames = None

    def next_frame(self):
        if self.frames:
            self.loc += 1
            self.loc %= len(self.frames)
            self.config(image=self.frames[self.loc])
            self.after(self.delay, self.next_frame)

class Application(tk.Frame):
    def __init__(self, master=None):
        super().__init__(master)
        self.master = master
        self.pack()
        self.create_widgets()
        self.make_widgets()

    def make_widgets(self):
        self.winfo_toplevel().title("Collison Warning System")

    def create_widgets(self):

        self.select = tk.Button(self, text="Select Image", fg="black", command = self.SelectImage)
        # self.select.config(height = 3 , width = 5)
        self.select.pack(side="top")

        self.infer = tk.Button(self, text = "Infer" , fg = "green",command = self.Infer)
        # self.infer.config(height = 5 , width = 5)
        self.infer.pack(side="top")

        self.output = tk.Button(self, text = "Output" , fg = "blue",command = self.Output)
        # self.infer.config(height = 5 , width = 5)
        self.output.pack(side="top")

        self.quit = tk.Button(self, text="QUIT", fg="red",command=self.master.destroy)
        self.quit.pack(side="bottom")


    def Infer(self):
        print("Infering {}.".format(root.filename))
        os.system("scp -i awsgpu.pem image.jpg ubuntu@ec2-52-21-223-125.compute-1.amazonaws.com:~/CollisionWarningSystem/monodepth/")
        k = paramiko.RSAKey.from_private_key_file("awsgpu.pem")
        c = paramiko.SSHClient()
        c.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        print("connecting")
        c.connect( hostname = "ec2-52-21-223-125.compute-1.amazonaws.com", username = "ubuntu", pkey = k )
        print("connected")
        commands = [ "bash sshgui_single.sh"]
        for command in commands:
            print("Executing {}".format( command ))
            stdin , stdout, stderr = c.exec_command(command)
            print(stdout.read())
            print("Errors")
            print(stderr.read())
        c.close()

    def SelectImage(self):
        root.filename = filedialog.askopenfilename(filetypes=[("Image File", '.png')])

    def Output(self):
        path=filedialog.askopenfilename(filetypes=[("Image File",'.png')])
        im = Image.open(path)
        tkimage = ImageTk.PhotoImage(im)
        myvar=Label(root,image = tkimage)
        myvar.image = tkimage
        myvar.pack()




root = tk.Tk()
lbl = ImageLabel(root)
lbl.pack()
lbl.load('giphy.gif')



app = Application(master=root)
app.mainloop()
