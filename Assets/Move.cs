using UnityEngine;

public class KeyboardMovement : MonoBehaviour
{
    [Header("Настройки движения")]
    public float moveSpeed = 5f;
    public float rotationSpeed = 100f;
    
    void Update()
    {
        // Движение вперед/назад
        float moveVertical = Input.GetAxis("Vertical"); 
        float moveHorizontal = Input.GetAxis("Horizontal"); 
        
        // Перемещение объекта
        Vector3 movement = new Vector3(moveHorizontal, 0f, moveVertical) * moveSpeed * Time.deltaTime;
        transform.Translate(movement, Space.Self);
    }
}