package cn.fx.desk.zoo;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;

/**
 * @author sunxy
 * @version 2015-7-6
 * @des
 **/
public class ObjectUtil {
	public static byte[] ObjectToByte(java.lang.Object obj) {
		byte[] bytes = null;
		ByteArrayOutputStream bo = null;
		ObjectOutputStream oo = null;
		try {
			bo = new ByteArrayOutputStream();
			oo = new ObjectOutputStream(bo);
			oo.writeObject(obj);
			bytes = bo.toByteArray();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (bo != null) {
				try {
					bo.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			if (oo != null) {
				try {
					oo.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
		return bytes;
	}

	public static Object ByteToObject(byte[] bytes) {
		Object obj = null;
		ByteArrayInputStream bi = null;
		ObjectInputStream oi = null;
		try {
			bi = new ByteArrayInputStream(bytes);
			oi = new ObjectInputStream(bi);
			obj = oi.readObject();
			bi.close();
			oi.close();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (bi != null) {
				try {
					bi.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			if (oi != null) {
				try {
					oi.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
		return obj;
	}

}
