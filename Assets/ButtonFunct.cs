using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class ButtonFunct : MonoBehaviour
{
    public void LoadScreen(int sceneIndex) 
    {
        SceneManager.LoadScene(sceneIndex);
    }
}